return {
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    config = function()
      local config = require("cord")

      -- Custom language handlers
      local handlers = {
        ["cpp"] = function(opts)
          return "Optimising " .. opts.filename
        end,
        ["rust"] = function(opts)
          return "Oxidising " .. opts.filename
        end,
        ["go"] = function(opts)
          return "Going " .. opts.filename
        end,
        ["python"] = function(opts)
          return "Snaking " .. opts.filename
        end,
      }

      config.setup({
        usercmds = true,           -- Enable user commands
        log_level = 'error',       -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
        timer = {
          interval = 1500,         -- Interval between presence updates in milliseconds (min 500)
          reset_on_idle = false,   -- Reset start timestamp on idle
          reset_on_change = false, -- Reset start timestamp on presence change
        },
        editor = {
          image = nil,                          -- Image ID or URL in case a custom client id is provided
          client = 'neovim',                    -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
          tooltip = 'The Superior Text Editor', -- Text to display when hovering over the editor's image
        },
        display = {
          theme = "default",
          flavor = "accent",
          show_time = true,             -- Display start timestamp
          show_repository = true,       -- Display 'View repository' button linked to repository url, if any
          show_cursor_position = false, -- Display line and column number of cursor's position
          swap_fields = false,          -- If enabled, workspace is displayed first
          swap_icons = false,           -- If enabled, editor is displayed on the main image
          workspace_blacklist = {},     -- List of workspace names that will hide rich presence
        },
        lsp = {
          show_problem_count = true, -- Display number of diagnostics problems
          severity = 1,              -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
          scope = 'workspace',       -- buffer or workspace
        },
        idle = {
          enable = true, -- Enable idle status
          show_status = true, -- Display idle status, disable to hide the rich presence on idle
          timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
          disable_on_focus = false, -- Do not display idle status when neovim is focused
          text = 'Idle', -- Text to display when idle
          tooltip = '💤', -- Text to display when hovering over the idle image
        },
        text = {
          viewing = function(opts)
            return ('Viewing ' .. opts.filename)
          end,
          editing = function(opts)
            return handlers[opts.filetype] and handlers[opts.filetype](opts) or ('Editing ' .. opts.filename)
          end,
          file_browser = function(opts)
            return ('Browsing files in ' .. opts.workspace)
          end,
          workspace = function(opts)
            return ('In ' .. opts.workspace)
          end,
        },

        assets = {
          ['Cargo.toml'] = { text = 'Managing Cargo dependencies...' },
          ['CMakeLists.txt'] = { text = 'Configuring build system...' },
          ['Dockerfile'] = { text = 'Containerising applications...' },
          ['docker-compose.yml'] = { text = 'Orchestrating containers...' },
        },
      })
    end
  }
}
