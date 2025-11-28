return {
  { import = "nvchad.blink.lazyspec" },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
    keys = {
      { "<leader>ca", false },
    },
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
  },

  -- {
  --   "rachartier/tiny-code-action.nvim",
  --   dependencies = {
  --       {"nvim-lua/plenary.nvim"},
  --       {
  --         "folke/snacks.nvim",
  --         opts = {
  --           terminal = {},
  --         }
  --       }
  --   },
  --   event = "LspAttach",
  --   opts = {
  --     backend = "delta",
  --     picker = "snacks",
  --     backend_opts = {
  --       delta = {
  --         header_lines_to_remove = 4,
  --         args = {
  --           "--line-numbers",
  --         },
  --       }
  --     }
  --   }
  -- },

  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    config = function()
      require("actions-preview").setup {
        highlight_command = {},
        backend = { "snacks" },
      }
    end,
  },

  { "nvim-tree/nvim-tree.lua", enabled = false },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true, replace_netrw = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      terminal = { enabled = true },
    },
  },

  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = false,
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      dofile(vim.g.base46_cache .. "grug_far")
      require("grug-far").setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
    end,
  },

  {
    "nvim-flutter/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = true,
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "sqlite" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { -- optional saghen/blink.cmp completion source
    "saghen/blink.cmp",
    build = "cargo +nightly build --release",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    event = "LspAttach",
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {
          winbar = {
            sections = { "console", "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
            default_section = "console",
            controls = {
              enabled = true,
              position = "right",
              buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
              },
            },
          },
        },
      },
    },
    config = function()
      dofile(vim.g.base46_cache .. "dap")
    end
  },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
  -- },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },
  {
    "mfussenegger/nvim-jdtls",
    event = "VeryLazy",
  },
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim"
    },
    opts = {
      plugins = {
        non_standalone = true
      }
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        notify = {
          replace = true,
        },
      },
      lsp = {
        progress = {
          view = "notify"
        },
        hover = {
          enabled = false
        },
        signature = {
          enabled = false
        }
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  }
}
