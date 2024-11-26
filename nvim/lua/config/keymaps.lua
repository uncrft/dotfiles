-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

---@param desc string
---@param override table|nil
---@return table|nil { silent = true, remap = true, desc = desc }
local function opts(desc, override)
  override = override or {}
  local default_opts = { silent = true, remap = false, desc = desc }
  return vim.tbl_deep_extend("force", default_opts, override)
end

-- colemak-dh remaps
-- -> normal and visual mode cursor movements
vim.keymap.set({ "n", "v", "x", "o" }, "n", "h", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "N", "H", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "e", "j", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "E", "J", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "i", "k", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "I", "K", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "o", "l", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "O", "L", opts("which_key_ignore"))
-- -> insert mode cursor movements
vim.keymap.set("i", "<C-n>", "<Left>", opts("Move Cursor Left"))
vim.keymap.set("i", "<C-e>", "<Down>", opts("Move Cursor Down"))
vim.keymap.set("i", "<C-i>", "<Up>", opts("Move Cursor Up"))
vim.keymap.set("i", "<C-o>", "<Right>", opts("Move Cursor Right"))
vim.keymap.set("i", "<C-b>", "<C-o>b", opts("Move Cursor Back One Word"))
vim.keymap.set("i", "<C-w>", "<C-o>w", opts("Move Cursor Forward One Word"))
-- -> invert keymaps
vim.keymap.set({ "n", "v", "x", "o" }, "h", "i", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "H", "I", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "j", "e", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "J", "mzJ`z", opts("Append Next Line"))
vim.keymap.set({ "n", "v", "x", "o" }, "k", "nzzzv", opts("Find Next"))
vim.keymap.set({ "n", "v", "x", "o" }, "K", "Nzzzv", opts("Find Previous"))
vim.keymap.set({ "n", "v", "x", "o" }, "l", "o", opts("which_key_ignore"))
vim.keymap.set({ "n", "v", "x", "o" }, "L", "O", opts("which_key_ignore"))
-- -> window navigation
vim.keymap.set("n", "<C-n>", "<C-w>h", opts("which_key_ignore"))
vim.keymap.set("n", "<C-e>", "<C-w>j", opts("which_key_ignore"))
vim.keymap.set("n", "<C-i>", "<C-w>k", opts("which_key_ignore"))
vim.keymap.set("n", "<C-o>", "<C-w>l", opts("which_key_ignore"))
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
-- -> move lines up and down
vim.keymap.set("n", "<A-e>", ":m .+1<CR>==", opts("Move Line Down"))
vim.keymap.set("v", "<A-e>", ":m '>+1<CR>gv=gv", opts("Move Line Down"))
vim.keymap.set("n", "<A-i>", ":m .-2<CR>==", opts("Move Line Up"))
vim.keymap.set("v", "<A-i>", ":m '<-2<CR>gv=gv", opts("Move Line Up"))

-- -> enter normal mode (not necessary with crkbd)
-- vim.keymap.set({ "i", "v" }, "tn", "<Esc>", opts("Enter Normal Mode"))
-- vim.keymap.set({ "i", "v" }, "nt", "<Esc>", opts("Enter Normal Mode"))

-- -> clipboard operations
vim.keymap.set("x", "<leader>p", '"_dP', opts("Paste Without Overriding Clipboard"))
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts("Yank To System Clipboard"))
vim.keymap.set("n", "<leader>Y", '"+Y', opts("Yank To System Clipboard (end of line)"))
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', opts("Delete Without Overriding Clipboard"))
vim.keymap.set("n", "<leader>D", '"_D', opts("Delete Without Overriding Clipboard (end of line)"))

-- -> page jumps
-- vim.cmd([[ nnoremap <expr> <C-y> (winheight(0) / 4) . "<C-d>zz" ]])
-- vim.cmd([[ nnoremap <expr> <C-u> (winheight(0) / 4) . "<C-u>zz" ]])
vim.keymap.set(
  { "n", "v" },
  "<C-u>",
  "(winheight(0) / 4) . '<C-d>zz'",
  opts("which_key_ignore", { expr = true })
  -- { silent = true, remap = false, expr = true, desc = "which_key_ignore" }
)
vim.keymap.set(
  { "n", "v" },
  "<C-y>",
  "(winheight(0) / 4) . '<C-u>zz'",
  opts("which_key_ignore", { expr = true })
  -- { silent = true, remap = false, expr = true, desc = "which_key_ignore" }
)
-- vim.keymap.set("n", "<C-y>", "<C-d>zz", opts("which_key_ignore"))
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", opts("which_key_ignore"))

vim.keymap.set("n", "<leader>fs", "<Cmd>w<CR>", opts("Save file"))
