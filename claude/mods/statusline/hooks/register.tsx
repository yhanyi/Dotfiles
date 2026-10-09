import type { EngineInterface, Register } from 'claude-code'
import { atom, read, update } from 'claude-code'
import type { Info, Limit } from '../types'

export type { Info }

const SEPARATOR = ' │ '
const REFRESH_MS = 30_000 // Refreshes after every turn and 30s.
const BAR_WIDTH = 8

// Catppuccin Macchiato.
const C = {
  subtext: '#a5adcb',
  overlay: '#6e738d',
  surface: '#494d64',
  green: '#a6da95',
  yellow: '#eed49f',
  red: '#ed8796',
  peach: '#f5a97f',
  teal: '#8bd5ca',
  mauve: '#c6a0f6',
  pink: '#f5bde6',
  blue: '#8aadf4',
  lavender: '#b7bdf8',
  flamingo: '#f0c6c6',
}

// Cache keepalive.
const KEEPALIVE = true
const CACHE_TTL_MS = 60 * 60_000 // API's default TTL.
const PING_EVERY_MS = CACHE_TTL_MS - 30_000
const MAX_PINGS = 1
const PING_PROMPT = 'Cache keepalive ping. Reply with only: ok'

// Phrases dropped from the engine's hint line under the prompt.
const HINT_NOISE = [/\(shift\+tab to cycle\)/gi, /←\s*for agents/gi, /\? for shortcuts/gi,]

type Part = { text: string; color: string }
const p = (text: string, color: string): Part => ({ text, color })

export function trimHint(hint: string): string {
  return HINT_NOISE.reduce((h, re) => h.replace(re, ''), hint)
    .split('·')
    .map(s => s.trim())
    .filter(Boolean)
    .join(' · ')
}

// Each segment turns Info into coloured parts or undefined.
const SEGMENTS: ((i: Info) => Part[] | undefined)[] = [
  i => i.context && [
    p('ctx ', C.subtext),
    ...bar(i.context.percent),
    p(` ${pct(i.context.percent)}`, heat(i.context.percent)),
    p(` ${tokens(i.context.tokens)}/${tokens(i.context.window)}`, C.overlay),
  ],
  i => i.fiveHour && [
    p('5h ', C.subtext),
    ...bar(i.fiveHour.percent),
    p(` ${pct(i.fiveHour.percent)}`, heat(i.fiveHour.percent)),
    ...resets(i.fiveHour, i.now),
  ],
  i => i.sevenDay && [
    p('7d ', C.subtext),
    p(pct(i.sevenDay.percent), heat(i.sevenDay.percent)),
    ...resets(i.sevenDay, i.now),
  ],
  i => i.costUsd !== undefined ? [p(`$${i.costUsd.toFixed(2)}`, C.peach)] : undefined,
  i => {
    const total = i.cache.read + i.cache.written + i.cache.uncached
    if (total === 0) return undefined
    return [
      p('cache ', C.subtext),
      p(`${pct((i.cache.read / total) * 100)} hit `, C.mauve),
      p(tokens(i.cache.read), C.blue),
      p(' read ', C.overlay),
      p(tokens(i.cache.written), C.lavender),
      p(' write ', C.overlay),
      p(tokens(i.cache.uncached), C.flamingo),
      p(' new', C.overlay),
    ]
  },
  i => i.keepalive.isArmed ? [p(`⟳ ${i.keepalive.pings}/${i.keepalive.max}`, C.pink)] : undefined,
]

function heat(percent: number): string {
  if (percent >= 80) return C.red
  if (percent >= 50) return C.yellow
  return C.green
}

function bar(percent: number): Part[] {
  const filled = Math.round((Math.min(Math.max(percent, 0), 100) / 100) * BAR_WIDTH)
  return [p('█'.repeat(filled), heat(percent)), p('░'.repeat(BAR_WIDTH - filled), C.surface)]
}

function pct(n: number): string {
  return `${Math.round(n)}%`
}

function resets(limit: Limit, now: number): Part[] {
  if (limit.resetsAt === undefined) return []
  return [p(` ↻ ${duration(limit.resetsAt - now)}`, C.teal)]
}

function duration(ms: number): string {
  const mins = Math.max(0, Math.round(ms / 60_000))
  const d = Math.floor(mins / 1440)
  const h = Math.floor((mins % 1440) / 60)
  const m = mins % 60
  if (d > 0) return `${d}d${h}h`
  if (h > 0) return `${h}h${String(m).padStart(2, '0')}m`
  return `${m}m`
}

function tokens(n: number): string {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}k`
  return String(n)
}

// Lives in session state to survive hot reloads.
const cache = atom({ plugin: 'statusline', key: 'cache' } as const, {
  read: 0,
  written: 0,
  uncached: 0,
})
// Last gathered Info, writing it redraws the band.
const latest = atom({ plugin: 'statusline', key: 'info' } as const, null)

// Keepalive state.
let pingTimer: { cancel: () => void } | undefined
let pings = 0

function disarm() {
  pingTimer?.cancel()
  pingTimer = undefined
}

function arm($: EngineInterface) {
  disarm()
  if (!KEEPALIVE || pings >= MAX_PINGS) return
  pingTimer = $.clock.after(PING_EVERY_MS, () => ping($))
}

async function ping($: EngineInterface) {
  pingTimer = undefined
  const r = await $.model.fork({ prompt: PING_PROMPT })
  if (!r.isAnswered && r.reason === 'nothing-to-fork') return
  pings++
  arm($)
  void refresh($)
}

async function gather($: EngineInterface): Promise<Info> {
  const [usage, totals, now] = await Promise.all([
    $.session.usage(),
    read($, cache),
    $.clock.now(),
  ])
  const limit = (kind: string): Limit | undefined => {
    const l = usage.rateLimits.find(r => r.kind === kind)
    if (!l) return undefined
    return { percent: l.percentUsed, resetsAt: l.resetsAt ? Date.parse(l.resetsAt) : undefined }
  }
  const ctx = usage.context
  return {
    now,
    context: ctx.percent !== undefined && ctx.tokens !== undefined
      ? { percent: ctx.percent, tokens: ctx.tokens, window: ctx.window }
      : undefined,
    fiveHour: limit('five_hour'),
    sevenDay: limit('seven_day'),
    costUsd: usage.cost?.usd,
    cache: totals,
    keepalive: { pings, max: MAX_PINGS, isArmed: pingTimer !== undefined || pings > 0 },
  }
}

export function parts(info: Info): Part[] {
  const segments = SEGMENTS.map(seg => seg(info)).filter((s): s is Part[] => s !== undefined)
  return segments.flatMap((s, n) => (n === 0 ? s : [p(SEPARATOR, C.surface), ...s]))
}

export function render(info: Info): string | undefined {
  return parts(info).map(x => x.text).join('') || undefined
}

async function refresh($: EngineInterface) {
  const info = await gather($)
  await update($, latest, () => info)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const result = await next(e)
    void refresh($)
    $.clock.every(REFRESH_MS, () => refresh($))
    return result
  })

  // Started typing.
  on('turn.start', async ($, e, next) => {
    disarm()
    pings = 0
    void refresh($)
    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    if (e.agentId === undefined) arm($)
    const u = e.usage
    if (u) {
      await update($, cache, c => ({
        read: c.read + u.cache_read_input_tokens,
        written: c.written + u.cache_creation_input_tokens,
        uncached: c.uncached + u.input_tokens,
      }))
    }
    void refresh($)
    return result
  })

  // Drawn in place of the hint line under the prompt.
  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const info = await read($, latest)
    const line = info ? parts(info) : []
    const hint = trimHint(e.props.hint)
    if (line.length === 0) {
      return hint === e.props.hint ? next(e) : next({ ...e, props: { ...e.props, hint } })
    }
    const { Box, Text } = $.ui.resolve(e)
    return (
      <Box flexDirection="column">
        {/* Trim the left of the separator dot. */}
        <Box marginLeft={-3}>
          <Text wrap="truncate">
            {[p(SEPARATOR, C.surface), ...line].map(x => <Text color={x.color}>{x.text}</Text>)}
          </Text>
        </Box>
        {hint ? <Text dimColor wrap="truncate">{hint}</Text> : null}
      </Box>
    )
  })
}
