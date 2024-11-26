return {
  {
    "catppuccin/nvim",
    lazy = true,
    priority = 1000,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      -- color_overrides = {
      -- mocha = {
      -- base = "#000000",
      -- mantle = "#000000",
      -- crust = "#000000",
      -- },
      -- },
      custom_highlights = function()
        return {
          CursorLine = { bg = "none" },
          CursorLineNr = { bold = true },
        }
      end,
      integrations = {
        alpha = true,
        cmp = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true },
        neotest = true,
        noice = true,
        notify = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl["Function"] = {
          fg = c.teal,
        }
        hl["@tag.tsx"] = {
          fg = c.orange,
        }

        hl.TelescopeNormal = {
          bg = c.transparent,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.transparent,
          fg = c.transparent,
        }
        hl.TelescopePromptNormal = {
          bg = c.transparent,
        }
        hl.TelescopePromptBorder = {
          bg = c.transparent,
          fg = c.transparent,
        }
        hl.TelescopePromptPrefix = {
          fg = c.orange,
        }
        hl.TelescopePromptTitle = {
          bg = c.transparent,
          fg = c.orange,
        }
        hl.TelescopePreviewTitle = {
          bg = c.transparent,
          fg = c.orange,
        }
        hl.TelescopeResultsTitle = {
          bg = c.transparent,
          fg = c.orange,
        }
        hl.TelescopeMatching = {
          fg = c.teal,
        }
        hl.GitGutterAdd = {
          fg = c.green2,
        }
        hl.NeoTreeGitModified = {
          fg = c.yellow,
        }
        hl.DashboardHeader = {
          fg = c.teal,
        }
        hl.DashboardFooter = {
          fg = c.teal,
        }
        hl.DashboardDesc = {
          fg = c.teal,
        }
        hl.DashboardIcon = {
          fg = c.orange,
        }
      end,
    },
  },
}
