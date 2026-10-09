export type CacheTotals = { read: number; written: number; uncached: number }

export type Limit = { percent: number; resetsAt?: number }
export type Info = {
  now: number
  context?: { percent: number; tokens: number; window: number }
  fiveHour?: Limit
  sevenDay?: Limit
  costUsd?: number
  cache: CacheTotals
  keepalive: { pings: number; max: number; isArmed: boolean }
}

declare module 'claude-code' {
  interface PluginState {
    statusline: { cache: CacheTotals; info: Info | null }
  }
}
