return {
  {
    "lukas-reineke/indent-blankline.nvim",
    tag = "v3.8.2",
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        object_scope = "hh",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
                                                                    
      ████ ██████           █████      ██                     
     ███████████             █████                             
     █████████ ███████████████████ ███   ███████████   
    █████████  ███    █████████████ █████ ██████████████   
   █████████ ██████████ █████████ █████ █████ ████ █████   
 ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████ 
          ]],
        },
        sections = function()
          local Snacks = require("snacks")

          return {
            { section = "header" },
            { section = "keys", padding = 1 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            {
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = Snacks.git.get_root() ~= nil,
              cmd = "git status --short --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
          }
        end,
      },
    },
  },
}
