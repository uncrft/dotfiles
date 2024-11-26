local function time()
  return " " .. os.date("%R")
end

return {
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    -- change some options
    opts = function(_, opts)
      local actions = require("telescope.actions")

      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          layout_strategy = "vertical",
          layout_config = { vertical = { preview_height = 0.70 } },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- add this value
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-W>"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
        },
      })
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = {
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
      }

      return vim.tbl_deep_extend("force", opts, {
        config = {
          header = logo,
        },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.theme = "tokyonight"
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = "|"
      opts.sections.lualine_a = { { "mode", separator = { left = "", right = "" }, padding = 0 } }
      opts.sections.lualine_b = { { "branch", separator = { right = "" }, padding = { left = 1, right = 0 } } }
      opts.sections.lualine_y = {
        { "progress", separator = " ", padding = 0 },
        { "location", padding = { left = 0, right = 1 } },
      }

      opts.sections.lualine_z = {
        {
          time,
          separator = { left = "", right = "" },
          padding = 0,
        },
      }
    end,
  },
  -- { "alexghergh/nvim-tmux-navigation" },
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    ft = { "typescript", "typescriptreact" },
    config = {
      auto_open_qflist = false,
    },
    keys = { { "<leader>ct", "<cmd>TSC<cr>", desc = "Type-check" } },
  },
  { "akinsho/bufferline.nvim", version = "4.4.*", enabled = false },
  {
    "neovim/nvim-lspconfig",
    ---@type lspconfig.options
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "svelte",
            "astro",
            "json",
            "json5",
            "jsonc",
          },

          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
          },
        },
      },
      setup = {
        eslint = function()
          local function get_client(buf)
            return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["n"] = "close_node",
          ["o"] = "open",
          ["h"] = "show_help",
          ["l"] = "none",
          ["k"] = "show_file_details",
          ["e"] = "none",
          ["i"] = "none",
          ["j"] = "toggle_auto_expand_width",
        },
      },
    },
  },
  -- {
  --   "yioneko/nvim-vtsls",
  --   ft = { "typescript", "typescriptreact", "javascript" },
  --   setup = true,
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
  --     end
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "yioneko/nvim-vtsls",
  --   },
  --   opts = {
  --     -- make sure mason installs the server
  --     servers = {
  --       ---@type lspconfig.options.vtsls
  --       ---@diagnostic disable-next-line: missing-fields
  --       vtsls = {},
  --       -- ---@type lspconfig.options.tsserver
  --       -- tsserver = {
  --       --   ---@diagnostic disable-next-line: missing-fields
  --       --   settings = {
  --       --     completions = {
  --       --       completeFunctionCalls = true,
  --       --     },
  --       --   },
  --       -- },
  --     },
  --     setup = {
  --       vtsls = function(_, opts)
  --         require("vtsls").setup({ servers = opts })
  --       end,
  --     },
  --   },
  -- },
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "jose-elias-alvarez/typescript.nvim",
  --     {
  --       "dmmulroy/ts-error-translator.nvim",
  --       ft = { "typescript", "typescriptreact" },
  --       setup = true,
  --     },
  --     init = function()
  --       require("lazyvim.util").lsp.on_attach(function(_, buffer)
  --         -- stylua: ignore
  --         vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
  --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
  --       end)
  --     end,
  --   },
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- tsserver will be automatically installed with mason and loaded with lspconfig
  --       tsserver = {},
  --     },
  --     -- you can do any additional lsp server setup here
  --     -- return true if you don't want this server to be setup with lspconfig
  --     ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
  --     setup = {
  --       -- example to setup with typescript.nvim
  --       tsserver = function(_, opts)
  --         require("typescript").setup({ server = opts })
  --         vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  --           require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
  --           vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
  --         end
  --
  --         return true
  --       end,
  --       -- Specify * to use this function as a fallback for any server
  --       -- ["*"] = function(server, opts) end,
  --     },
  --   },
  -- },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {
  --     settings = {
  --       expose_as_code_action = "all",
  --       -- code_lens = "all",
  --       tsserver_plugins = {
  --         "@styled/typescript-styled-plugin",
  --       },
  --     },
  --   },
  -- },
}
