-- TokyoNight.

-- Prevent double-loading
if vim.g.tokyonight_loaded then return end
vim.g.tokyonight_loaded = true

local M = {}

-- HSLuv (colour math libary).
local hsluv = {}
do
  local hexChars = "0123456789abcdef"
  local distance_line_from_origin = function(line)
    return math.abs(line.intercept) / math.sqrt((line.slope ^ 2) + 1)
  end
  local length_of_ray_until_intersect = function(theta, line)
    return line.intercept / (math.sin(theta) - line.slope * math.cos(theta))
  end
  hsluv.get_bounds = function(l)
    local result = {}
    local sub2
    local sub1 = ((l + 16) ^ 3) / 1560896
    if sub1 > hsluv.epsilon then sub2 = sub1 else sub2 = l / hsluv.kappa end
    for i = 1, 3 do
      local m1, m2, m3 = hsluv.m[i][1], hsluv.m[i][2], hsluv.m[i][3]
      for t = 0, 1 do
        local top1 = (284517 * m1 - 94839 * m3) * sub2
        local top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * l * sub2 - 769860 * t * l
        local bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t
        table.insert(result, { slope = top1 / bottom, intercept = top2 / bottom })
      end
    end
    return result
  end
  hsluv.max_safe_chroma_for_l = function(l)
    local bounds = hsluv.get_bounds(l)
    local min = 1.7976931348623157e+308
    for i = 1, 6 do
      local length = distance_line_from_origin(bounds[i])
      if length >= 0 then min = math.min(min, length) end
    end
    return min
  end
  hsluv.max_safe_chroma_for_lh = function(l, h)
    local hrad = h / 360 * math.pi * 2
    local bounds = hsluv.get_bounds(l)
    local min = 1.7976931348623157e+308
    for i = 1, 6 do
      local length = length_of_ray_until_intersect(hrad, bounds[i])
      if length >= 0 then min = math.min(min, length) end
    end
    return min
  end
  hsluv.dot_product = function(a, b)
    local sum = 0
    for i = 1, 3 do sum = sum + a[i] * b[i] end
    return sum
  end
  hsluv.from_linear = function(c)
    if c <= 0.0031308 then return 12.92 * c
    else return 1.055 * (c ^ 0.416666666666666685) - 0.055 end
  end
  hsluv.to_linear = function(c)
    if c > 0.04045 then return ((c + 0.055) / 1.055) ^ 2.4
    else return c / 12.92 end
  end
  hsluv.xyz_to_rgb = function(tuple)
    return {
      hsluv.from_linear(hsluv.dot_product(hsluv.m[1], tuple)),
      hsluv.from_linear(hsluv.dot_product(hsluv.m[2], tuple)),
      hsluv.from_linear(hsluv.dot_product(hsluv.m[3], tuple)),
    }
  end
  hsluv.rgb_to_xyz = function(tuple)
    local rgbl = { hsluv.to_linear(tuple[1]), hsluv.to_linear(tuple[2]), hsluv.to_linear(tuple[3]) }
    return {
      hsluv.dot_product(hsluv.minv[1], rgbl),
      hsluv.dot_product(hsluv.minv[2], rgbl),
      hsluv.dot_product(hsluv.minv[3], rgbl),
    }
  end
  hsluv.y_to_l = function(Y)
    if Y <= hsluv.epsilon then return Y / hsluv.refY * hsluv.kappa
    else return 116 * ((Y / hsluv.refY) ^ 0.333333333333333315) - 16 end
  end
  hsluv.l_to_y = function(L)
    if L <= 8 then return hsluv.refY * L / hsluv.kappa
    else return hsluv.refY * (((L + 16) / 116) ^ 3) end
  end
  hsluv.xyz_to_luv = function(tuple)
    local X, Y = tuple[1], tuple[2]
    local divider = X + 15 * Y + 3 * tuple[3]
    local varU, varV = 4 * X, 9 * Y
    if divider ~= 0 then varU = varU / divider; varV = varV / divider
    else varU = 0; varV = 0 end
    local L = hsluv.y_to_l(Y)
    if L == 0 then return { 0, 0, 0 } end
    return { L, 13 * L * (varU - hsluv.refU), 13 * L * (varV - hsluv.refV) }
  end
  hsluv.luv_to_xyz = function(tuple)
    local L, U, V = tuple[1], tuple[2], tuple[3]
    if L == 0 then return { 0, 0, 0 } end
    local varU = U / (13 * L) + hsluv.refU
    local varV = V / (13 * L) + hsluv.refV
    local Y = hsluv.l_to_y(L)
    local X = 0 - (9 * Y * varU) / (((varU - 4) * varV) - varU * varV)
    return { X, Y, (9 * Y - 15 * varV * Y - varV * X) / (3 * varV) }
  end
  hsluv.luv_to_lch = function(tuple)
    local L, U, V = tuple[1], tuple[2], tuple[3]
    local C = math.sqrt(U * U + V * V)
    local H
    if C < 0.00000001 then H = 0
    else
      H = math.atan2(V, U) * 180.0 / 3.1415926535897932
      if H < 0 then H = 360 + H end
    end
    return { L, C, H }
  end
  hsluv.lch_to_luv = function(tuple)
    local Hrad = tuple[3] / 360.0 * 2 * math.pi
    return { tuple[1], math.cos(Hrad) * tuple[2], math.sin(Hrad) * tuple[2] }
  end
  hsluv.hsluv_to_lch = function(tuple)
    local H, S, L = tuple[1], tuple[2], tuple[3]
    if L > 99.9999999 then return { 100, 0, H } end
    if L < 0.00000001 then return { 0, 0, H } end
    return { L, hsluv.max_safe_chroma_for_lh(L, H) / 100 * S, H }
  end
  hsluv.lch_to_hsluv = function(tuple)
    local L, C, H = tuple[1], tuple[2], tuple[3]
    if L > 99.9999999 then return { H, 0, 100 } end
    if L < 0.00000001 then return { H, 0, 0 } end
    return { H, C / hsluv.max_safe_chroma_for_lh(L, H) * 100, L }
  end
  hsluv.lch_to_rgb  = function(t) return hsluv.xyz_to_rgb(hsluv.luv_to_xyz(hsluv.lch_to_luv(t))) end
  hsluv.rgb_to_lch  = function(t) return hsluv.luv_to_lch(hsluv.xyz_to_luv(hsluv.rgb_to_xyz(t))) end
  hsluv.hsluv_to_rgb = function(t) return hsluv.lch_to_rgb(hsluv.hsluv_to_lch(t)) end
  hsluv.rgb_to_hsluv = function(t) return hsluv.lch_to_hsluv(hsluv.rgb_to_lch(t)) end
  hsluv.rgb_to_hex = function(tuple)
    local h = "#"
    for i = 1, 3 do
      local c = math.floor(tuple[i] * 255 + 0.5)
      local d2 = math.fmod(c, 16)
      local d1 = math.floor((c - d2) / 16)
      h = h .. string.sub(hexChars, d1 + 1, d1 + 1) .. string.sub(hexChars, d2 + 1, d2 + 1)
    end
    return h
  end
  hsluv.hex_to_rgb = function(hex)
    hex = string.lower(hex)
    local ret = {}
    for i = 0, 2 do
      local c1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
      local c2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
      ret[i + 1] = ((string.find(hexChars, c1) - 1) * 16 + (string.find(hexChars, c2) - 1)) / 255.0
    end
    return ret
  end
  hsluv.hsluv_to_hex = function(t) return hsluv.rgb_to_hex(hsluv.hsluv_to_rgb(t)) end
  hsluv.hex_to_hsluv = function(s) return hsluv.rgb_to_hsluv(hsluv.hex_to_rgb(s)) end
  hsluv.m    = { { 3.240969941904521, -1.537383177570093, -0.498610760293 }, { -0.96924363628087, 1.87596750150772, 0.041555057407175 }, { 0.055630079696993, -0.20397695888897, 1.056971514242878 } }
  hsluv.minv = { { 0.41239079926595, 0.35758433938387, 0.18048078840183 }, { 0.21263900587151, 0.71516867876775, 0.072192315360733 }, { 0.019330818715591, 0.11919477979462, 0.95053215224966 } }
  hsluv.refY = 1.0; hsluv.refU = 0.19783000664283; hsluv.refV = 0.46831999493879
  hsluv.kappa = 903.2962962; hsluv.epsilon = 0.0088564516
end

-- Utils.
local Util = {}
do
  Util.bg = "#000000"
  Util.fg = "#ffffff"
  Util.day_brightness = 0.3

  local function rgb(c)
    c = string.lower(c)
    return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
  end

  function Util.blend(foreground, alpha, background)
    alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
    local bg, fg = rgb(background), rgb(foreground)
    local function ch(i)
      return math.floor(math.min(math.max(0, alpha * fg[i] + (1 - alpha) * bg[i]), 255) + 0.5)
    end
    return string.format("#%02x%02x%02x", ch(1), ch(2), ch(3))
  end

  function Util.blend_bg(hex, amount, bg) return Util.blend(hex, amount, bg or Util.bg) end
  Util.darken = Util.blend_bg
  function Util.blend_fg(hex, amount, fg) return Util.blend(hex, amount, fg or Util.fg) end
  Util.lighten = Util.blend_fg

  function Util.invert(color)
    if type(color) == "table" then
      for k, v in pairs(color) do color[k] = Util.invert(v) end
    elseif type(color) == "string" and color ~= "NONE" then
      local hsl = hsluv.hex_to_hsluv(color)
      hsl[3] = 100 - hsl[3]
      if hsl[3] < 40 then hsl[3] = hsl[3] + (100 - hsl[3]) * Util.day_brightness end
      return hsluv.hsluv_to_hex(hsl)
    end
    return color
  end

  function Util.brighten(color, l_amt, s_amt)
    l_amt = l_amt or 0.05; s_amt = s_amt or 0.2
    local hsl = hsluv.hex_to_hsluv(color)
    hsl[3] = math.min(hsl[3] + l_amt * 100, 100)
    hsl[2] = math.min(hsl[2] + s_amt * 100, 100)
    return hsluv.hsluv_to_hex(hsl)
  end

  function Util.resolve(groups)
    for _, hl in pairs(groups) do
      if type(hl.style) == "table" then
        for k, v in pairs(hl.style) do hl[k] = v end
        hl.style = nil
      end
    end
    return groups
  end

  local uv = vim.uv or vim.loop
  Util.cache = {}
  function Util.cache.file(key) return vim.fn.stdpath("cache") .. "/tokyonight-" .. key .. ".json" end
  function Util.cache.read(key)
    local ok, ret = pcall(function()
      local fd = io.open(Util.cache.file(key), "r")
      if not fd then return nil end
      local data = fd:read("*a"); fd:close()
      return vim.json.decode(data, { luanil = { object = true, array = true } })
    end)
    return ok and ret or nil
  end
  function Util.cache.write(key, data)
    pcall(function()
      local path = Util.cache.file(key)
      vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
      local fd = io.open(path, "w+")
      if fd then fd:write(vim.json.encode(data)); fd:close() end
    end)
  end
  function Util.cache.clear()
    for _, style in ipairs({ "storm", "day", "night", "moon" }) do
      uv.fs_unlink(Util.cache.file(style))
    end
  end
end

-- Config.
local Config = {}
do
  Config.version = "4.14.1"
  Config.defaults = {
    style = "moon",
    light_style = "day",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments  = { italic = true },
      keywords  = { italic = true },
      functions = {},
      variables = {},
      sidebars  = "dark",
      floats    = "dark",
    },
    day_brightness = 0.3,
    dim_inactive = false,
    lualine_bold = false,
    on_colors     = function(colors) end,
    on_highlights = function(highlights, colors) end,
    cache = true,
    plugins = {
      all  = package.loaded.lazy == nil,
      auto = true,
    },
  }
  Config.options = nil
  function Config.setup(options)
    Config.options = vim.tbl_deep_extend("force", {}, Config.defaults, options or {})
  end
  function Config.extend(opts)
    return opts and vim.tbl_deep_extend("force", {}, Config.options, opts) or Config.options
  end
  setmetatable(Config, {
    __index = function(_, k)
      if k == "options" then return Config.defaults end
    end,
  })
end

-- Palettes.
local palettes = {}
do
  palettes.storm = {
    bg = "#24283b", bg_dark = "#1f2335", bg_dark1 = "#1b1e2d",
    bg_highlight = "#292e42",
    blue = "#7aa2f7", blue0 = "#3d59a1", blue1 = "#2ac3de", blue2 = "#0db9d7",
    blue5 = "#89ddff", blue6 = "#b4f9f8", blue7 = "#394b70",
    comment = "#565f89", cyan = "#7dcfff", dark3 = "#545c7e", dark5 = "#737aa2",
    fg = "#c0caf5", fg_dark = "#a9b1d6", fg_gutter = "#3b4261",
    green = "#9ece6a", green1 = "#73daca", green2 = "#41a6b5",
    magenta = "#bb9af7", magenta2 = "#ff007c", orange = "#ff9e64",
    purple = "#9d7cd8", red = "#f7768e", red1 = "#db4b4b", teal = "#1abc9c",
    terminal_black = "#414868", yellow = "#e0af68",
    git = { add = "#449dab", change = "#6183bb", delete = "#914c54" },
  }

  palettes.night = vim.tbl_deep_extend("force", vim.deepcopy(palettes.storm), {
    bg = "#1a1b26", bg_dark = "#16161e", bg_dark1 = "#0C0E14",
  })

  palettes.moon = {
    bg = "#222436", bg_dark = "#1e2030", bg_dark1 = "#191B29",
    bg_highlight = "#2f334d",
    blue = "#82aaff", blue0 = "#3e68d7", blue1 = "#65bcff", blue2 = "#0db9d7",
    blue5 = "#89ddff", blue6 = "#b4f9f8", blue7 = "#394b70",
    comment = "#636da6", cyan = "#86e1fc", dark3 = "#545c7e", dark5 = "#737aa2",
    fg = "#c8d3f5", fg_dark = "#828bb8", fg_gutter = "#3b4261",
    green = "#c3e88d", green1 = "#4fd6be", green2 = "#41a6b5",
    magenta = "#c099ff", magenta2 = "#ff007c", orange = "#ff966c",
    purple = "#fca7ea", red = "#ff757f", red1 = "#c53b53", teal = "#4fd6be",
    terminal_black = "#444a73", yellow = "#ffc777",
    git = { add = "#b8db87", change = "#7ca1f2", delete = "#e26a75" },
  }

  -- day is a runtime inversion of another style
  palettes.day = nil -- handled in colors.setup
end

-- Colours.
local Colors = {}
do
  function Colors.setup(opts)
    opts = Config.extend(opts)
    Util.day_brightness = opts.day_brightness

    local palette
    if opts.style == "day" then
      -- invert the light_style palette
      local base_style = opts.light_style or "night"
      if base_style == "day" then base_style = "night" end
      palette = vim.deepcopy(palettes[base_style])
      Util.invert(palette)
      palette.bg_dark  = Util.blend(palette.bg, 0.9, palette.fg)
      palette.bg_dark1 = Util.blend(palette.bg_dark, 0.9, palette.fg)
    else
      palette = vim.deepcopy(palettes[opts.style] or palettes.moon)
    end

    local c = palette
    Util.bg = c.bg
    Util.fg = c.fg
    c.none  = "NONE"

    c.diff = {
      add    = Util.blend_bg(c.green2, 0.25),
      delete = Util.blend_bg(c.red1,   0.25),
      change = Util.blend_bg(c.blue7,  0.15),
      text   = c.blue7,
    }
    c.git.ignore     = c.dark3
    c.black          = Util.blend_bg(c.bg, 0.8, "#000000")
    c.border_highlight = Util.blend_bg(c.blue1, 0.8)
    c.border         = c.black
    c.bg_popup       = c.bg_dark
    c.bg_statusline  = c.bg_dark
    c.bg_sidebar     = opts.styles.sidebars == "transparent" and c.none
                       or opts.styles.sidebars == "dark"    and c.bg_dark
                       or c.bg
    c.bg_float       = opts.styles.floats == "transparent" and c.none
                       or opts.styles.floats == "dark"      and c.bg_dark
                       or c.bg
    c.bg_visual  = Util.blend_bg(c.blue0, 0.4)
    c.bg_search  = c.blue0
    c.fg_sidebar = c.fg_dark
    c.fg_float   = c.fg
    c.error      = c.red1
    c.todo       = c.blue
    c.warning    = c.yellow
    c.info       = c.blue2
    c.hint       = c.teal
    c.rainbow    = { c.blue, c.yellow, c.green, c.teal, c.magenta, c.purple, c.orange, c.red }
    c.terminal   = {
      black          = c.black,
      black_bright   = c.terminal_black,
      red            = c.red,            red_bright    = Util.brighten(c.red),
      green          = c.green,          green_bright  = Util.brighten(c.green),
      yellow         = c.yellow,         yellow_bright = Util.brighten(c.yellow),
      blue           = c.blue,           blue_bright   = Util.brighten(c.blue),
      magenta        = c.magenta,        magenta_bright= Util.brighten(c.magenta),
      cyan           = c.cyan,           cyan_bright   = Util.brighten(c.cyan),
      white          = c.fg_dark,        white_bright  = c.fg,
    }
    opts.on_colors(c)
    return c, opts
  end
end

-- Highlight groups.
local Groups = {}
do
  -- base groups
  local function get_base(c, opts)
    -- stylua: ignore
    return {
      Comment                     = { fg = c.comment, style = opts.styles.comments },
      ColorColumn                 = { bg = c.black },
      Conceal                     = { fg = c.dark5 },
      Cursor                      = { fg = c.bg, bg = c.fg },
      lCursor                     = { fg = c.bg, bg = c.fg },
      CursorIM                    = { fg = c.bg, bg = c.fg },
      CursorColumn                = { bg = c.bg_highlight },
      CursorLine                  = { bg = c.bg_highlight },
      Directory                   = { fg = c.blue },
      DiffAdd                     = { bg = c.diff.add },
      DiffChange                  = { bg = c.diff.change },
      DiffDelete                  = { bg = c.diff.delete },
      DiffText                    = { bg = c.diff.text },
      EndOfBuffer                 = { fg = c.bg },
      ErrorMsg                    = { fg = c.error },
      VertSplit                   = { fg = c.border },
      WinSeparator                = { fg = c.border, bold = true },
      Folded                      = { fg = c.blue, bg = c.fg_gutter },
      FoldColumn                  = { bg = opts.transparent and c.none or c.bg, fg = c.comment },
      SignColumn                  = { bg = opts.transparent and c.none or c.bg, fg = c.fg_gutter },
      SignColumnSB                = { bg = c.bg_sidebar, fg = c.fg_gutter },
      Substitute                  = { bg = c.red, fg = c.black },
      LineNr                      = { fg = c.fg_gutter },
      CursorLineNr                = { fg = c.orange, bold = true },
      LineNrAbove                 = { fg = c.fg_gutter },
      LineNrBelow                 = { fg = c.fg_gutter },
      MatchParen                  = { fg = c.orange, bold = true },
      ModeMsg                     = { fg = c.fg_dark, bold = true },
      MsgArea                     = { fg = c.fg_dark },
      MoreMsg                     = { fg = c.blue },
      NonText                     = { fg = c.dark3 },
      Normal                      = { fg = c.fg, bg = opts.transparent and c.none or c.bg },
      NormalNC                    = { fg = c.fg, bg = opts.transparent and c.none or opts.dim_inactive and c.bg_dark or c.bg },
      NormalSB                    = { fg = c.fg_sidebar, bg = c.bg_sidebar },
      NormalFloat                 = { fg = c.fg_float, bg = c.bg_float },
      FloatBorder                 = { fg = c.border_highlight, bg = c.bg_float },
      FloatTitle                  = { fg = c.border_highlight, bg = c.bg_float },
      Pmenu                       = { bg = c.bg_popup, fg = c.fg },
      PmenuMatch                  = { bg = c.bg_popup, fg = c.blue1 },
      PmenuSel                    = { bg = Util.blend_bg(c.fg_gutter, 0.8) },
      PmenuMatchSel               = { bg = Util.blend_bg(c.fg_gutter, 0.8), fg = c.blue1 },
      PmenuSbar                   = { bg = Util.blend_fg(c.bg_popup, 0.95) },
      PmenuThumb                  = { bg = c.fg_gutter },
      Question                    = { fg = c.blue },
      QuickFixLine                = { bg = c.bg_visual, bold = true },
      Search                      = { bg = c.bg_search, fg = c.fg },
      IncSearch                   = { bg = c.orange, fg = c.black },
      CurSearch                   = "IncSearch",
      SpecialKey                  = { fg = c.dark3 },
      SpellBad                    = { sp = c.error, undercurl = true },
      SpellCap                    = { sp = c.warning, undercurl = true },
      SpellLocal                  = { sp = c.info, undercurl = true },
      SpellRare                   = { sp = c.hint, undercurl = true },
      StatusLine                  = { fg = c.fg_sidebar, bg = c.bg_statusline },
      StatusLineNC                = { fg = c.fg_gutter, bg = c.bg_statusline },
      TabLine                     = { bg = c.bg_statusline, fg = c.fg_gutter },
      TabLineFill                 = { bg = opts.transparent and c.none or c.black },
      TabLineSel                  = { fg = c.black, bg = c.blue },
      Title                       = { fg = c.blue, bold = true },
      Visual                      = { bg = c.bg_visual },
      VisualNOS                   = { bg = c.bg_visual },
      WarningMsg                  = { fg = c.warning },
      Whitespace                  = { fg = c.fg_gutter },
      WildMenu                    = { bg = c.bg_visual },
      WinBar                      = "StatusLine",
      WinBarNC                    = "StatusLineNC",
      Bold                        = { bold = true, fg = c.fg },
      Character                   = { fg = c.green },
      Constant                    = { fg = c.orange },
      Debug                       = { fg = c.orange },
      Delimiter                   = "Special",
      Error                       = { fg = c.error },
      Function                    = { fg = c.blue, style = opts.styles.functions },
      Identifier                  = { fg = c.magenta, style = opts.styles.variables },
      Italic                      = { italic = true, fg = c.fg },
      Keyword                     = { fg = c.cyan, style = opts.styles.keywords },
      Operator                    = { fg = c.blue5 },
      PreProc                     = { fg = c.cyan },
      Special                     = { fg = c.blue1 },
      Statement                   = { fg = c.magenta },
      String                      = { fg = c.green },
      Todo                        = { bg = c.yellow, fg = c.bg },
      Type                        = { fg = c.blue1 },
      Underlined                  = { underline = true },
      debugBreakpoint             = { bg = Util.blend_bg(c.info, 0.1), fg = c.info },
      debugPC                     = { bg = c.bg_sidebar },
      dosIniLabel                 = "@property",
      helpCommand                 = { bg = c.terminal_black, fg = c.blue },
      htmlH1                      = { fg = c.magenta, bold = true },
      htmlH2                      = { fg = c.blue, bold = true },
      qfFileName                  = { fg = c.blue },
      qfLineNr                    = { fg = c.dark5 },
      LspReferenceText            = { bg = c.fg_gutter },
      LspReferenceRead            = { bg = c.fg_gutter },
      LspReferenceWrite           = { bg = c.fg_gutter },
      LspSignatureActiveParameter = { bg = Util.blend_bg(c.bg_visual, 0.4), bold = true },
      LspCodeLens                 = { fg = c.comment },
      LspInlayHint                = { bg = Util.blend_bg(c.blue7, 0.1), fg = c.dark3 },
      LspInfoBorder               = { fg = c.border_highlight, bg = c.bg_float },
      DiagnosticError             = { fg = c.error },
      DiagnosticWarn              = { fg = c.warning },
      DiagnosticInfo              = { fg = c.info },
      DiagnosticHint              = { fg = c.hint },
      DiagnosticUnnecessary       = { fg = c.terminal_black },
      DiagnosticVirtualTextError  = { bg = Util.blend_bg(c.error,   0.1), fg = c.error },
      DiagnosticVirtualTextWarn   = { bg = Util.blend_bg(c.warning, 0.1), fg = c.warning },
      DiagnosticVirtualTextInfo   = { bg = Util.blend_bg(c.info,    0.1), fg = c.info },
      DiagnosticVirtualTextHint   = { bg = Util.blend_bg(c.hint,    0.1), fg = c.hint },
      DiagnosticUnderlineError    = { undercurl = true, sp = c.error },
      DiagnosticUnderlineWarn     = { undercurl = true, sp = c.warning },
      DiagnosticUnderlineInfo     = { undercurl = true, sp = c.info },
      DiagnosticUnderlineHint     = { undercurl = true, sp = c.hint },
      healthError                 = { fg = c.error },
      healthSuccess               = { fg = c.green1 },
      healthWarning               = { fg = c.warning },
      diffAdded                   = { bg = c.diff.add,    fg = c.git.add },
      diffRemoved                 = { bg = c.diff.delete, fg = c.git.delete },
      diffChanged                 = { bg = c.diff.change, fg = c.git.change },
      diffOldFile                 = { fg = c.blue1, bg = c.diff.delete },
      diffNewFile                 = { fg = c.blue1, bg = c.diff.add },
      diffFile                    = { fg = c.blue },
      diffLine                    = { fg = c.comment },
      diffIndexLine               = { fg = c.magenta },
      helpExample                 = { fg = c.comment },
    }
  end

  -- treesitter groups
  local function get_treesitter(c, opts)
    local ret = {
      ["@annotation"]                 = "PreProc",
      ["@attribute"]                  = "PreProc",
      ["@boolean"]                    = "Boolean",
      ["@character"]                  = "Character",
      ["@character.printf"]           = "SpecialChar",
      ["@character.special"]          = "SpecialChar",
      ["@comment"]                    = "Comment",
      ["@comment.error"]              = { fg = c.error },
      ["@comment.hint"]               = { fg = c.hint },
      ["@comment.info"]               = { fg = c.info },
      ["@comment.note"]               = { fg = c.hint },
      ["@comment.todo"]               = { fg = c.todo },
      ["@comment.warning"]            = { fg = c.warning },
      ["@constant"]                   = "Constant",
      ["@constant.builtin"]           = "Special",
      ["@constant.macro"]             = "Define",
      ["@constructor"]                = { fg = c.magenta },
      ["@constructor.tsx"]            = { fg = c.blue1 },
      ["@diff.delta"]                 = "DiffChange",
      ["@diff.minus"]                 = "DiffDelete",
      ["@diff.plus"]                  = "DiffAdd",
      ["@function"]                   = "Function",
      ["@function.builtin"]           = "Special",
      ["@function.call"]              = "@function",
      ["@function.macro"]             = "Macro",
      ["@function.method"]            = "Function",
      ["@function.method.call"]       = "@function.method",
      ["@keyword"]                    = { fg = c.purple, style = opts.styles.keywords },
      ["@keyword.conditional"]        = "Conditional",
      ["@keyword.coroutine"]          = "@keyword",
      ["@keyword.debug"]              = "Debug",
      ["@keyword.directive"]          = "PreProc",
      ["@keyword.directive.define"]   = "Define",
      ["@keyword.exception"]          = "Exception",
      ["@keyword.function"]           = { fg = c.magenta, style = opts.styles.functions },
      ["@keyword.import"]             = "Include",
      ["@keyword.operator"]           = "@operator",
      ["@keyword.repeat"]             = "Repeat",
      ["@keyword.return"]             = "@keyword",
      ["@keyword.storage"]            = "StorageClass",
      ["@label"]                      = { fg = c.blue },
      ["@markup"]                     = "@none",
      ["@markup.emphasis"]            = { italic = true },
      ["@markup.environment"]         = "Macro",
      ["@markup.environment.name"]    = "Type",
      ["@markup.heading"]             = "Title",
      ["@markup.italic"]              = { italic = true },
      ["@markup.link"]                = { fg = c.teal },
      ["@markup.link.label"]          = "SpecialChar",
      ["@markup.link.label.symbol"]   = "Identifier",
      ["@markup.link.url"]            = "Underlined",
      ["@markup.list"]                = { fg = c.blue5 },
      ["@markup.list.checked"]        = { fg = c.green1 },
      ["@markup.list.markdown"]       = { fg = c.orange, bold = true },
      ["@markup.list.unchecked"]      = { fg = c.blue },
      ["@markup.math"]                = "Special",
      ["@markup.raw"]                 = "String",
      ["@markup.raw.markdown_inline"] = { bg = c.terminal_black, fg = c.blue },
      ["@markup.strikethrough"]       = { strikethrough = true },
      ["@markup.strong"]              = { bold = true },
      ["@markup.underline"]           = { underline = true },
      ["@module"]                     = "Include",
      ["@module.builtin"]             = { fg = c.red },
      ["@namespace.builtin"]          = "@variable.builtin",
      ["@none"]                       = {},
      ["@number"]                     = "Number",
      ["@number.float"]               = "Float",
      ["@operator"]                   = { fg = c.blue5 },
      ["@property"]                   = { fg = c.green1 },
      ["@punctuation.bracket"]        = { fg = c.fg_dark },
      ["@punctuation.delimiter"]      = { fg = c.blue5 },
      ["@punctuation.special"]        = { fg = c.blue5 },
      ["@punctuation.special.markdown"] = { fg = c.orange },
      ["@string"]                     = "String",
      ["@string.documentation"]       = { fg = c.yellow },
      ["@string.escape"]              = { fg = c.magenta },
      ["@string.regexp"]              = { fg = c.blue6 },
      ["@tag"]                        = "Label",
      ["@tag.attribute"]              = "@property",
      ["@tag.delimiter"]              = "Delimiter",
      ["@tag.delimiter.tsx"]          = { fg = Util.blend_bg(c.blue, 0.7) },
      ["@tag.tsx"]                    = { fg = c.red },
      ["@tag.javascript"]             = { fg = c.red },
      ["@type"]                       = "Type",
      ["@type.builtin"]               = { fg = Util.blend_bg(c.blue1, 0.8) },
      ["@type.definition"]            = "Typedef",
      ["@type.qualifier"]             = "@keyword",
      ["@variable"]                   = { fg = c.fg, style = opts.styles.variables },
      ["@variable.builtin"]           = { fg = c.red },
      ["@variable.member"]            = { fg = c.green1 },
      ["@variable.parameter"]         = { fg = c.yellow },
      ["@variable.parameter.builtin"] = { fg = Util.blend_fg(c.yellow, 0.8) },
    }
    for i, color in ipairs(c.rainbow) do
      ret["@markup.heading." .. i .. ".markdown"] = { fg = color, bold = true, bg = Util.blend_bg(color, 0.1) }
    end
    return ret
  end

  -- semantic token groups
  local function get_semantic_tokens(c)
    return {
      ["@lsp.type.boolean"]                      = "@boolean",
      ["@lsp.type.builtinType"]                  = "@type.builtin",
      ["@lsp.type.comment"]                      = "@comment",
      ["@lsp.type.decorator"]                    = "@attribute",
      ["@lsp.type.deriveHelper"]                 = "@attribute",
      ["@lsp.type.enum"]                         = "@type",
      ["@lsp.type.enumMember"]                   = "@constant",
      ["@lsp.type.escapeSequence"]               = "@string.escape",
      ["@lsp.type.formatSpecifier"]              = "@markup.list",
      ["@lsp.type.generic"]                      = "@variable",
      ["@lsp.type.interface"]                    = { fg = Util.blend_fg(c.blue1, 0.7) },
      ["@lsp.type.keyword"]                      = "@keyword",
      ["@lsp.type.lifetime"]                     = "@keyword.storage",
      ["@lsp.type.namespace"]                    = "@module",
      ["@lsp.type.namespace.python"]             = "@variable",
      ["@lsp.type.number"]                       = "@number",
      ["@lsp.type.operator"]                     = "@operator",
      ["@lsp.type.parameter"]                    = "@variable.parameter",
      ["@lsp.type.property"]                     = "@property",
      ["@lsp.type.selfKeyword"]                  = "@variable.builtin",
      ["@lsp.type.selfTypeKeyword"]              = "@variable.builtin",
      ["@lsp.type.string"]                       = "@string",
      ["@lsp.type.typeAlias"]                    = "@type.definition",
      ["@lsp.type.unresolvedReference"]          = { undercurl = true, sp = c.error },
      ["@lsp.type.variable"]                     = {},
      ["@lsp.typemod.class.defaultLibrary"]      = "@type.builtin",
      ["@lsp.typemod.enum.defaultLibrary"]       = "@type.builtin",
      ["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
      ["@lsp.typemod.function.defaultLibrary"]   = "@function.builtin",
      ["@lsp.typemod.keyword.async"]             = "@keyword.coroutine",
      ["@lsp.typemod.keyword.injected"]          = "@keyword",
      ["@lsp.typemod.macro.defaultLibrary"]      = "@function.builtin",
      ["@lsp.typemod.method.defaultLibrary"]     = "@function.builtin",
      ["@lsp.typemod.operator.injected"]         = "@operator",
      ["@lsp.typemod.string.injected"]           = "@string",
      ["@lsp.typemod.struct.defaultLibrary"]     = "@type.builtin",
      ["@lsp.typemod.type.defaultLibrary"]       = { fg = Util.blend_bg(c.blue1, 0.8) },
      ["@lsp.typemod.typeAlias.defaultLibrary"]  = { fg = Util.blend_bg(c.blue1, 0.8) },
      ["@lsp.typemod.variable.callable"]         = "@function",
      ["@lsp.typemod.variable.defaultLibrary"]   = "@variable.builtin",
      ["@lsp.typemod.variable.injected"]         = "@variable",
      ["@lsp.typemod.variable.static"]           = "@constant",
    }
  end

  -- LSP kind groups
  local function get_kinds()
    local kinds = {
      Array = "@punctuation.bracket", Boolean = "@boolean", Class = "@type",
      Color = "Special", Constant = "@constant", Constructor = "@constructor",
      Enum = "@lsp.type.enum", EnumMember = "@lsp.type.enumMember", Event = "Special",
      Field = "@variable.member", File = "Normal", Folder = "Directory",
      Function = "@function", Interface = "@lsp.type.interface", Key = "@variable.member",
      Keyword = "@lsp.type.keyword", Method = "@function.method", Module = "@module",
      Namespace = "@module", Null = "@constant.builtin", Number = "@number",
      Object = "@constant", Operator = "@operator", Package = "@module",
      Property = "@property", Reference = "@markup.link", Snippet = "Conceal",
      String = "@string", Struct = "@lsp.type.struct", Unit = "@lsp.type.struct",
      Text = "@markup", TypeParameter = "@lsp.type.typeParameter", Variable = "@variable",
      Value = "@string",
    }
    local hl = {}
    for kind, link in pairs(kinds) do hl["LspKind" .. kind] = link end
    return hl
  end

  function Groups.setup(c, opts)
    local ret = {}
    local function merge(tbl)
      for k, v in pairs(tbl) do ret[k] = v end
    end
    merge(get_base(c, opts))
    merge(get_treesitter(c, opts))
    merge(get_semantic_tokens(c))
    merge(get_kinds())
    Util.resolve(ret)
    return ret
  end
end

-- Theme.
local Theme = {}
do
  function Theme.terminal(colors)
    local t = colors.terminal
    vim.g.terminal_color_0  = t.black
    vim.g.terminal_color_8  = t.black_bright
    vim.g.terminal_color_7  = t.white
    vim.g.terminal_color_15 = t.white_bright
    vim.g.terminal_color_1  = t.red;     vim.g.terminal_color_9  = t.red_bright
    vim.g.terminal_color_2  = t.green;   vim.g.terminal_color_10 = t.green_bright
    vim.g.terminal_color_3  = t.yellow;  vim.g.terminal_color_11 = t.yellow_bright
    vim.g.terminal_color_4  = t.blue;    vim.g.terminal_color_12 = t.blue_bright
    vim.g.terminal_color_5  = t.magenta; vim.g.terminal_color_13 = t.magenta_bright
    vim.g.terminal_color_6  = t.cyan;    vim.g.terminal_color_14 = t.cyan_bright
  end

  function Theme.setup(opts)
    opts = Config.extend(opts)
    local colors, resolved_opts = Colors.setup(opts)

    -- check cache
    local cache_key = opts.style
    local cache = opts.cache and Util.cache.read(cache_key)
    local cache_inputs = {
      colors = colors,
      version = Config.version,
      opts = { transparent = opts.transparent, styles = opts.styles, dim_inactive = opts.dim_inactive },
    }
    local groups
    if cache and vim.deep_equal(cache_inputs, cache.inputs) then
      groups = cache.groups
    else
      groups = Groups.setup(colors, resolved_opts)
      if opts.cache then
        Util.cache.write(cache_key, { groups = groups, inputs = cache_inputs })
      end
    end

    opts.on_highlights(groups, colors)

    if vim.g.colors_name then vim.cmd("hi clear") end
    vim.o.termguicolors = true
    vim.g.colors_name = "tokyonight-" .. opts.style

    for group, hl in pairs(groups) do
      hl = type(hl) == "string" and { link = hl } or hl
      vim.api.nvim_set_hl(0, group, hl)
    end

    if opts.terminal_colors then Theme.terminal(colors) end
    return colors, groups, opts
  end
end

-- API.
M.styles = {}

function M.setup(opts)
  Config.setup(opts)
end

function M.load(opts)
  opts = Config.extend(opts)
  local bg = vim.o.background
  local style_bg = opts.style == "day" and "light" or "dark"
  if bg ~= style_bg then
    if vim.g.colors_name == "tokyonight-" .. opts.style then
      opts.style = bg == "light" and (M.styles.light or "day") or (M.styles.dark or "moon")
    else
      vim.o.background = style_bg
    end
  end
  M.styles[vim.o.background] = opts.style
  return Theme.setup(opts)
end

-- Expose util for advanced users (e.g. lighten/darken in their own config)
M.util = Util

-- Register as a Neovim colorscheme so `colorscheme tokyonight` works.
-- Neovim calls the colorscheme file automatically, but since this is a
-- single-file module, we hook into the ColorSchemePre event instead.
vim.api.nvim_create_autocmd("ColorSchemePre", {
  pattern = { "tokyonight", "tokyonight-storm", "tokyonight-moon", "tokyonight-night", "tokyonight-day" },
  once = false,
  callback = function(ev)
    local style = ev.match:match("tokyonight%-(.+)$")
    M.load(style and { style = style } or nil)
    -- Return true cancels further processing (we've already applied it)
    return true
  end,
})

return M
