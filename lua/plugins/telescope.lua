return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = (build_cmd ~= "cmake") and "make"
        or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = build_cmd ~= nil,
      config = function(plugin)
        LazyVim.on_load("telescope.nvim", function()
          local ok, err = pcall(require("telescope").load_extension, "fzf")
          if not ok then
            local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
            if not vim.uv.fs_stat(lib) then
              LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
              require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
              end)
            else
              LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
            end
          end
        end)
      end,
    },
    -- 添加 project.nvim 作为依赖
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          -- 检测项目的方法
          detection_methods = {},
          -- 项目根目录的标识文件
          patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "Makefile",
            "package.json",
            "pom.xml",
            "Cargo.toml",
            "go.mod",
            "requirements.txt",
            "setup.py",
            "pyproject.toml",
            "composer.json",
          },
          -- 忽略的目录
          exclude_dirs = {
            "~/.cargo/*",
            "~/.npm/*",
            "~/.cache/*",
          },
          -- 当离开项目时是否显示隐藏的文件
          show_hidden = true,
          -- 当进入项目时不自动改变目录
          silent_chdir = false,
        })
        -- 集成到 Telescope
        LazyVim.on_load("telescope.nvim", function()
          require("telescope").load_extension("projects")
        end)
      end,
    },
  },
  keys = {
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>/", false },
    -- { "<leader>/", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader><space>", false },
    -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    -- find
    {
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "Buffers",
    },
    { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
    { "<leader>ff", false },
    { "<leader>fF", false },
    -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fo", false },
    { "<leader>fO", false },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    { "<leader>fO", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
    { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
    { "<leader>sW", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
    { "<leader>sw", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
    { "<leader>sW", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
    { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol (Workspace)",
    },

    -- ===== 新增的项目感知搜索快捷键 =====
    {
      "<leader>sp",
      function()
        -- 获取当前文件所在的目录
        local current_file = vim.fn.expand("%:p")
        local current_dir = vim.fn.fnamemodify(current_file, ":h")

        -- 如果当前没有文件，使用当前工作目录
        if current_file == "" then
          current_dir = vim.uv.cwd()
        end

        -- 配置选项
        local opts = {
          prompt_title = "Search in: " .. vim.fn.fnamemodify(current_dir, ":t"),
          cwd = current_dir,
          -- 使用更高效的搜索参数
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!.git/*",
            "--glob",
            "!node_modules/*",
            "--glob",
            "!*.lock",
          },
          -- 添加路径显示
          path_display = { "truncate" },
        }

        require("telescope.builtin").live_grep(opts)
      end,
      desc = "Search in Current File's Directory",
    },

    {
      "<leader>sP",
      function()
        -- 显示当前项目信息
        local project_ok, project = pcall(require, "project_nvim.project")
        local root = nil
        if project_ok then
          root = project.get_project_root()
        end

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
      end,
      desc = "Show Project Info",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    local open_with_trouble = function(...)
      return require("trouble.sources.telescope").open(...)
    end
    local find_files_no_ignore = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
    end
    local find_files_with_hidden = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { hidden = true, default_text = line })()
    end

    local function find_command()
      if 1 == vim.fn.executable("rg") then
        return { "rg", "--files", "--color", "never", "-g", "!.git" }
      elseif 1 == vim.fn.executable("fd") then
        return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("fdfind") then
        return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
        return { "find", ".", "-type", "f" }
      elseif 1 == vim.fn.executable("where") then
        return { "where", "/r", ".", "*" }
      end
    end

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        mappings = {
          i = {
            ["<c-t>"] = open_with_trouble,
            ["<a-t>"] = open_with_trouble,
            ["<a-i>"] = find_files_no_ignore,
            ["<a-h>"] = find_files_with_hidden,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
          },
          n = {
            ["q"] = actions.close,
            ["t"] = actions.select_tab,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = find_command,
          hidden = true,
        },
      },
    }
  end,
}
