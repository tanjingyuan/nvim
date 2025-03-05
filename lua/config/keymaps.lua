-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", ";", ":", { noremap = true, silent = false })
map("n", "<C-q>", ":<leader>bd<CR>", { noremap = true, silent = true })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "next Buffer" })
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "prev Buffer" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
-- vim.keymap.set("n", "<C-n>", function()
--   require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
-- end, { desc = "Explorer NeoTree (Root Dir)" })

vim.keymap.set("n", "<C-S-n>", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer NeoTree (cwd)" })

-- telescope
map("n", "<leader>fW", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

-- map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
-- map(
--   "n",
--   "<leader>fa",
--   "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
--   { desc = "telescope find all files" }
-- )

-- fzf
-- map('n', '<leader>fw', "<cmd>lua require('fzf-lua').live_grep()<CR>")
-- map('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>")
-- map('n', '<leader>fo', "<cmd>lua require('fzf-lua').oldfiles()<CR>")

-- terminal
map("n", "<A-h>", function()
  vim.cmd("ToggleTerm direction=horizontal")
end, { desc = "Terminal (cwd)" })

-- format
vim.keymap.del({ "v" }, "<leader>cf")
-- vim.keymap.set("v", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>")
map("v", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range (in visual mode)" })

-- hop
map("n", "<leader>h", "<cmd>lua require'hop'.hint_lines()<CR>", { desc = "hop line" })

-- diffview
map("n", "<leader>gdo", "<cmd>DiffviewOpen<CR>", { desc = "diffview open" })
map("n", "<leader>gdc", "<cmd>DiffviewClose<CR>", { desc = "diffview close" })

--marks
-- delete all marks
map("n", "<leader>dam", function()
  -- 执行第一条命令
  vim.cmd("delmarks a-z")

  -- 执行第二条命令（这里需要替换为您想要的第二条命令）
  vim.cmd("delmarks A-Z")
  vim.cmd("delmarks 0-9")

  -- 执行 wshada!
  vim.cmd("wshada!")

  -- 可选：显示一个提示消息
  vim.notify("Marks deleted and shada file updated!")
end, { desc = "Delete all marks" })

-- delete marks
-- 获取当前光标的位置
vim.api.nvim_set_keymap("n", "<leader>dm", "", {
  noremap = true,
  silent = true,
  callback = function()
    local current_line = vim.fn.line('.')
    local marks = vim.fn.execute("marks")
    for line in marks:gmatch("[^\r\n]+") do
      local mark, lnum = line:match("^%s*(%S)%s+(%d+)")
      if mark and tonumber(lnum) == current_line then
        vim.cmd("delmarks " .. mark)
        vim.cmd("wshada!")
        vim.notify("Mark '" .. mark .. "' deleted from line " .. current_line .. " and shada file updated!", vim.log.levels.INFO)
        return
      end
    end
    vim.notify("No mark found on the current line.", vim.log.levels.WARN)
  end,
  desc = "Delete current line's mark and update shada"
})

-- clangd
map("n", "<leader>gh", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Jump to Header" })

-- preivew
map("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "Goto Definition" })
map("n", "gl", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { desc = "Goto Declaration" })
map("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "Close All" })

-- call graph
map("n", "<leader>cg", "<cmd>CallGraphR<CR>", { desc = "Generate Call Graph" })

--avante
map("n", "<leader>al", "<cmd>AvanteClear history<CR>", { desc = "Clear Avgante history" })
