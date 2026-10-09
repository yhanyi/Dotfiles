export type CacheTotals = { read: number; written: number; uncached: number }

declare module 'claude-code' {
  interface PluginState {
    statusline: { cache: CacheTotals }
  }
}
