import { test, expect } from 'claude-code/testing'
import { render } from './register'

const HOUR = 3_600_000
const empty = { read: 0, written: 0, uncached: 0 }
const idle = { pings: 0, max: 6, isArmed: false }

test('shows limits with reset countdowns, cost, and cache hit rate', () => {
  const line = render({
    now: 0,
    fiveHour: { percent: 50, resetsAt: 2 * HOUR + 13 * 60_000 },
    sevenDay: { percent: 18.4, resetsAt: 76 * HOUR },
    costUsd: 1.234,
    cache: { read: 900_000, written: 50_000, uncached: 50_000 },
    keepalive: { pings: 2, max: 6, isArmed: true },
  })
  expect(line).toBe('5h ████░░░░ 50% ↻ 2h13m  │  7d 18% ↻ 3d4h  │  $1.23  │  cache 90% hit (900.0k read)  │  ⟳ 2/6')
})

test('hides segments with no data', () => {
  expect(render({ now: 0, costUsd: 0, cache: empty, keepalive: idle })).toBe('$0.00')
  expect(render({ now: 0, cache: empty, keepalive: idle })).toBeUndefined()
})
