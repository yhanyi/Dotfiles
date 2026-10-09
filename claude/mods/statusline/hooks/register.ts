import type { EngineInterface, Register } from 'claude-code'
import { atom, read, update } from 'claude-code'
import type { CacheTotals } from '../types'

type Limit = { percent: number; resetsAt?: number }
export type Info = {
  now: number
  fiveHour?: Limit
  sevenDay?: Limit
  costUsd?: number
  cache: CacheTotals
  keepalive: { pings: number; max: number; isArmed: boolean }
}

const SEPARATOR = '  │  '
const REFRESH_MS = 30_000 // Refreshes after every turn and 30s.
const BAR_WIDTH = 8

// Cache keepalive.
const KEEPALIVE = true
const CACHE_TTL_MS = 60 * 60_000 // API's default TTL.
const PING_EVERY_MS = CACHE_TTL_MS - 30_000
const MAX_PINGS = 1
const PING_PROMPT = 'Cache keepalive ping. Reply with only: ok'

// Each segment turns Info into a string or undefined.
const SEGMENTS: ((i: Info) => string | undefined)[] = [
  i => i.fiveHour && `5h ${bar(i.fiveHour.percent)} ${pct(i.fiveHour.percent)}${resets(i.fiveHour, i.now)}`,
  i => i.sevenDay && `7d ${pct(i.sevenDay.percent)}${resets(i.sevenDay, i.now)}`,
  i => i.costUsd !== undefined ? `$${i.costUsd.toFixed(2)}` : undefined,
  i => {
    const total = i.cache.read + i.cache.written + i.cache.uncached
    if (total === 0) return undefined
    return `cache ${pct((i.cache.read / total) * 100)} hit (${tokens(i.cache.read)} read)`
  },
  i => i.keepalive.isArmed ? `⟳ ${i.keepalive.pings}/${i.keepalive.max}` : undefined,
]

function bar(percent: number): string {
  const filled = Math.round((Math.min(Math.max(percent, 0), 100) / 100) * BAR_WIDTH)
  return '█'.repeat(filled) + '░'.repeat(BAR_WIDTH - filled)
}

function pct(n: number): string {
  return `${Math.round(n)}%`
}

function resets(limit: Limit, now: number): string {
  if (limit.resetsAt === undefined) return ''
  return ` ↻ ${duration(limit.resetsAt - now)}`
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
  return {
    now,
    fiveHour: limit('five_hour'),
    sevenDay: limit('seven_day'),
    costUsd: usage.cost?.usd,
    cache: totals,
    keepalive: { pings, max: MAX_PINGS, isArmed: pingTimer !== undefined || pings > 0 },
  }
}

export function render(info: Info): string | undefined {
  return SEGMENTS.map(seg => seg(info)).filter(Boolean).join(SEPARATOR) || undefined
}

async function refresh($: EngineInterface) {
  $.ui.status(render(await gather($)))
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
}
