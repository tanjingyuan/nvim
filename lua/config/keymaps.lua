-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local autocmds = require("config.autocmds")
local map = vim.keymap.set

map("n", ";", ":", { noremap = true, silent = false })
-- Buffer delete with smart split handling
map("n", "<leader>bd", function()
  -- 获取当前窗口数量
  local win_count = #vim.api.nvim_list_wins()

  -- 检查当前窗口是否是固定窗口
  if vim.wo.winfixbuf then
    -- 如果是固定窗口，先解除固定，然后删除buffer并关闭窗口
    vim.wo.winfixbuf = false
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("close")
    -- 尝试删除缓冲区（如果没有其他窗口使用它）
    pcall(vim.api.nvim_buf_delete, buf, { force = false })
  elseif win_count > 1 then
    -- 如果有分屏（多个窗口），关闭当前窗口而不是只删除 buffer
    local buf = vim.api.nvim_get_current_buf()

    -- 先关闭窗口（取消分屏）
    vim.cmd("close")

    -- 检查这个 buffer 是否还在其他窗口中打开
    local buf_wins = vim.fn.win_findbuf(buf)
    if #buf_wins == 0 then
      -- 如果没有其他窗口使用这个 buffer，删除它
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  else
    -- 只有一个窗口时，使用默认的 buffer 删除功能
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.bufdelete then
      snacks.bufdelete()
    else
      -- 如果 snacks 不可用，使用基本的 bdelete
      vim.cmd("bdelete")
    end
  end
end, { desc = "Delete Buffer (smart split handling)" })

-- Buffer delete others with support for fixed windows
map("n", "<leader>bo", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      -- 查找使用此缓冲区的窗口
      local wins = vim.fn.win_findbuf(buf)
      for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) then
          -- 如果窗口是固定窗口，先解除固定再关闭
          if vim.api.nvim_win_get_option(win, "winfixbuf") then
            vim.api.nvim_win_set_option(win, "winfixbuf", false)
            vim.api.nvim_win_close(win, false)
          end
        end
      end
      -- 删除缓冲区
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end
  vim.notify("Deleted all other buffers", vim.log.levels.INFO)
end, { desc = "Delete Other Buffers (supports fixed windows)" })

map("n", "<C-q>", "<leader>bd", { remap = true, silent = true })

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
      vim.api.nvim_buf_set_keymap(0, "t", "<ESC>", [[<C-\><C-n>]], { noremap = true, silent = true })
      -- 设置 'q' 键在普通模式下关闭终端
      vim.api.nvim_buf_set_keymap(0, "n", "q", [[<cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
      -- 设置 'i' 键在普通模式下进入插入模式
      vim.api.nvim_buf_set_keymap(0, "n", "i", [[i]], { noremap = true, silent = true })

      -- 设置终端打开时自动进入插入模式
      vim.cmd("startinsert")
    end,
    once = true,
  })
end, { desc = "Open terminal in current buffer's directory" })

-- Open shell config based on current shell
map("n", "<leader>fs", function()
  local shell = vim.env.SHELL or vim.o.shell
  local config_file

  if shell:match("zsh") then
    config_file = vim.fn.expand("~/.zshrc")
  elseif shell:match("bash") then
    config_file = vim.fn.expand("~/.bashrc")
  else
    vim.notify("未知的 shell 类型: " .. shell, vim.log.levels.WARN)
    return
  end

  -- 检查文件是否存在
  if vim.fn.filereadable(config_file) == 1 then
    vim.cmd("edit " .. config_file)
  else
    vim.notify("配置文件不存在: " .. config_file, vim.log.levels.ERROR)
  end
end, { desc = "Open shell config" })

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
    local current_line = vim.fn.line(".")
    local marks = vim.fn.execute("marks")
    for line in marks:gmatch("[^\r\n]+") do
      local mark, lnum = line:match("^%s*(%S)%s+(%d+)")
      if mark and tonumber(lnum) == current_line then
        vim.cmd("delmarks " .. mark)
        vim.cmd("wshada!")
        vim.notify(
          "Mark '" .. mark .. "' deleted from line " .. current_line .. " and shada file updated!",
          vim.log.levels.INFO
        )
        return
      end
    end
    vim.notify("No mark found on the current line.", vim.log.levels.WARN)
  end,
  desc = "Delete current line's mark and update shada",
})

-- clangd
map("n", "<leader>gh", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Switch Source/Header" })

-- preivew
map("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "Goto Definition" })
map("n", "gl", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", { desc = "Goto Declaration" })
map("n", "q", "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "Close All" })

-- call graph
map("n", "<leader>cg", "<cmd>CallGraphR<CR>", { desc = "Generate Call Graph" })

--avante
map("n", "<leader>al", "<cmd>AvanteClear history<CR>", { desc = "Clear Avgante history" })

-- copilot (cmd = "Copilot" 会在执行命令时自动加载插件)
map("n", "<leader>ct", "<cmd>Copilot toggle<CR>", { desc = "Toggle Copilot" })
map("n", "<leader>cs", "<cmd>Copilot status<CR>", { desc = "Copilot Status" })
map("n", "<leader>cp", "<cmd>Copilot panel<CR>", { desc = "Copilot Panel" })

--project
map("n", "<leader>pp", "<cmd>ProjectRoot<CR>", { desc = "Project Root" })
map("n", "<leader>pa", autocmds.add_project, { desc = "Add Project" })

--显示空白字符
map("n", "<leader>uo", function()
  local list = vim.opt.list:get()
  if not list then
    vim.opt.list = true
    vim.opt.listchars = { tab = "»·", trail = "•", space = "·", eol = "↲", nbsp = "␣" }
    -- 设置空白字符的高亮颜色
    vim.cmd("highlight Whitespace guifg=#f38ba8")
    vim.cmd("highlight SpecialKey guifg=#f5c2e7 gui=bold")
    vim.notify("显示空白字符已开启", vim.log.levels.INFO)
  else
    vim.opt.list = false
    vim.notify("显示空白字符已关闭", vim.log.levels.INFO)
  end
end, { desc = "切换显示空白字符" })

--切换自定义高亮
map("n", "<leader>uH", function()
  require("utils.highlight").toggle()
end, { desc = "切换自定义高亮" })
