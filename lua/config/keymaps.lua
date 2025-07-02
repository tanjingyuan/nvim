-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local autocmds = require("config.autocmds")
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

-- Cd dir
vim.keymap.set("n", "<leader>cd", function()
  -- 获取当前 buffer 的完整路径
  local buf_name = vim.api.nvim_buf_get_name(0)
  -- 获取当前 buffer 所在的目录
  local buf_dir = vim.fn.fnamemodify(buf_name, ":p:h")

  -- 打开一个新的终端并 cd 到 buffer 所在目录
  vim.cmd("ToggleTerm direction=float")
  -- vim.cmd("ToggleTerm direction=horizontal")
  vim.cmd("TermExec cmd='cd " .. buf_dir .. "'")

  -- 设置当前终端 buffer 的局部键映射，按 'q' 关闭终端
  vim.api.nvim_create_autocmd("TermEnter", {
    pattern = "term://*toggleterm#*",
    callback = function()
      -- 设置 ESC 键在终端模式下切换到普通模式
      vim.api.nvim_buf_set_keymap(0, 't', '<ESC>', [[<C-\><C-n>]], { noremap = true, silent = true })
      -- 设置 'q' 键在普通模式下关闭终端
      vim.api.nvim_buf_set_keymap(0, 'n', 'q', [[<cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
      -- 设置 'i' 键在普通模式下进入插入模式
      vim.api.nvim_buf_set_keymap(0, 'n', 'i', [[i]], { noremap = true, silent = true })

      -- 设置终端打开时自动进入插入模式
      vim.cmd("startinsert")
    end,
    once = true
  })
end, { desc = "Open terminal in current buffer's directory" })

-- telescope
map("n", "<leader>fW", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
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
        vim.notify("Mark '" .. mark .. "' deleted from line " .. current_line .. " and shada file updated!",
          vim.log.levels.INFO)
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

--project
map("n", "<leader>pp", "<cmd>ProjectRoot<CR>", { desc = "Project Root" })
map("n", "<leader>pa", autocmds.add_project, { desc = "Add Project" })

--显示空白字符
map("n", "<leader>uo", function()
  local list = vim.opt.list:get()
  if not list then
    vim.opt.list = true
    vim.opt.listchars = { tab = '»·', trail = '•', space = '·', eol = '↲', nbsp = '␣' }
    -- 设置空白字符的高亮颜色
    vim.cmd("highlight Whitespace guifg=#f38ba8")
    vim.cmd("highlight SpecialKey guifg=#f5c2e7 gui=bold")
    vim.notify("显示空白字符已开启", vim.log.levels.INFO)
  else
    vim.opt.list = false
    vim.notify("显示空白字符已关闭", vim.log.levels.INFO)
  end
end, { desc = "切换显示空白字符" })
