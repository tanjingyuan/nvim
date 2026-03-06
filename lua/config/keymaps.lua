-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local autocmds = require("config.autocmds")
local map = vim.keymap.set

local function load_lazy_plugin(plugin)
  if not plugin then
    return
  end
  local ok, lazy = pcall(require, "lazy")
  if ok then
    pcall(lazy.load, { plugins = { plugin } })
  end
end

local function run_optional_command(command, opts)
  opts = opts or {}
  return function()
    load_lazy_plugin(opts.plugin)
    local cmd_name = command:match("^([%w_]+)")
    if cmd_name and vim.fn.exists(":" .. cmd_name) ~= 2 then
      vim.notify(opts.missing or ("命令不可用: " .. cmd_name), vim.log.levels.WARN)
      return
    end
    vim.cmd(command)
  end
end

local function get_neotree_path()
  local ok_neo, neo_manager = pcall(require, "neo-tree.sources.manager")
  if not ok_neo then
    return nil
  end
  local state = neo_manager.get_state("filesystem")
  return state and state.path or nil
end

local function pick_terminal_buffers()
  Snacks.picker.buffers({
    hidden = true,
    current = false,
    nofile = true,
    title = "终端缓冲区",
    filter = {
      filter = function(item)
        return item.buftype == "terminal"
      end,
    },
  })
end

map("n", ";", ":", { noremap = true, silent = false })
-- Buffer delete with smart split handling
map("n", "<leader>bd", function()
  local current_buf = vim.api.nvim_get_current_buf()
  -- 仅统计可见的正常窗口（排除浮窗）以避免误判最后一个窗口
  local normal_win_count = #vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))

  if vim.wo.winfixbuf then
    vim.wo.winfixbuf = false
  end

  if normal_win_count > 1 then
    local closed = pcall(vim.cmd, "close")
    -- 关闭窗口后，如果 buffer 已不在其他窗口中，则删除 buffer
    if closed then
      local buf_wins = vim.fn.win_findbuf(current_buf)
      if #buf_wins == 0 then
        pcall(vim.api.nvim_buf_delete, current_buf, { force = false })
      end
    else
      -- 关闭失败（例如仍被视为最后窗口）则直接删 buffer
      pcall(vim.api.nvim_buf_delete, current_buf, { force = false })
    end
  else
    -- 只有一个正常窗口时，使用默认的 buffer 删除功能
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.bufdelete then
      snacks.bufdelete()
    else
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

-- search
map("n", "<leader>fz", function()
  Snacks.picker.lines({
    title = "当前缓冲区精确搜索",
    matcher = {
      fuzzy = false,
    },
  })
end, { desc = "snacks exact find in current buffer" })
map("n", "<leader>cm", function() Snacks.picker.git_log() end, { desc = "git commits" })
map("n", "<leader>gt", function() Snacks.picker.git_status() end, { desc = "git status" })
map("n", "<leader>pt", pick_terminal_buffers, { desc = "pick hidden terminal" })

-- Snacks: 在项目中查找所有文件（包含隐藏和被.gitignore忽略）
map("n", "<leader><space>", function()
  local neo_tree_path = get_neotree_path()

  local ok, Snacks = pcall(require, "snacks")
  if ok then
    Snacks.picker.files({
      cwd = neo_tree_path,
      hidden = true,
      ignored = true,
      follow = true,
    })
    return
  end

  local ok_fzf, fzf = pcall(require, "fzf-lua")
  if ok_fzf then
    fzf.files({
      cwd = neo_tree_path,
      prompt_title = "Find Files in current Neo-tree Path",
      fd_opts = "--type f --hidden --no-ignore --exclude .git",
    })
    return
  end

  vim.notify("Snacks 和 fzf-lua 都未加载", vim.log.levels.ERROR)
end, { desc = "Find files (all, include .gitignore)" })

map("n", "<leader>sp", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = current_file ~= "" and vim.fs.dirname(vim.fs.normalize(current_file)) or vim.uv.cwd()

  Snacks.picker.grep({
    cwd = current_dir,
    hidden = true,
    exclude = { ".git/*", "node_modules/*", "*.lock" },
    title = "Search in: " .. vim.fn.fnamemodify(current_dir, ":t"),
  })
end, { desc = "Search in Current File's Directory" })

map("n", "<leader>sP", function()
  local root = LazyVim.root() or vim.uv.cwd()
  local current_dir = vim.uv.cwd()
  local current_file = vim.fn.expand("%:p")
  local info = string.format(
    [[
Project Root: %s
Current Directory: %s
Current File: %s
Search Scope: %s
]],
    root or "Not in a project",
    current_dir,
    current_file,
    root or current_dir
  )

  vim.notify(info, vim.log.levels.INFO, { title = "Project Info" })
end, { desc = "Show Project Info" })

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
map(
  "n",
  "<leader>gdo",
  run_optional_command("DiffviewOpen", { plugin = "diffview.nvim", missing = "Diffview 未安装" }),
  { desc = "Diffview Open" }
)
map(
  "n",
  "<leader>gdc",
  run_optional_command("DiffviewClose", { plugin = "diffview.nvim", missing = "Diffview 未安装" }),
  { desc = "Diffview Close" }
)

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

-- call graph
map(
  "n",
  "<leader>cg",
  run_optional_command("CallGraphR", { missing = "Call graph 命令不可用" }),
  { desc = "Generate Call Graph" }
)

--avante
map(
  "n",
  "<leader>al",
  run_optional_command("AvanteClear history", { plugin = "avante.nvim", missing = "Avante 未安装" }),
  { desc = "Clear Avante history" }
)

-- copilot (cmd = "Copilot" 会在执行命令时自动加载插件)
map(
  "n",
  "<leader>ct",
  run_optional_command("Copilot toggle", { plugin = "copilot.lua", missing = "Copilot 未安装" }),
  { desc = "Toggle Copilot" }
)
map(
  "n",
  "<leader>cp",
  run_optional_command("Copilot panel", { plugin = "copilot.lua", missing = "Copilot 未安装" }),
  { desc = "Copilot Panel" }
)

--project
map("n", "<leader>pp", function()
  local root = LazyVim.root() or vim.uv.cwd()

  if not root or root == "" then
    vim.notify("无法识别项目根目录", vim.log.levels.WARN)
    return
  end

  vim.cmd("cd " .. vim.fn.fnameescape(root))
  vim.notify("Project root: " .. root, vim.log.levels.INFO)
end, { desc = "Project Root" })
map("n", "<leader>pa", function()
  -- 添加项目，但不使用 git root
  autocmds.add_project(false, false)
end, { desc = "Add Current Directory as Project" })
map("n", "<leader>pd", autocmds.add_project_debug, { desc = "Add Project (Debug)" })

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
