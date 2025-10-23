return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
    -- because `cwd` is not set up properly.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      mappings = {
        ["o"] = false,
        ["t"] = false,
        ["c"] = false,
        ["t"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["s"] = {
          function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              -- 移动到最右侧窗口
              vim.cmd("wincmd l")
              while vim.fn.winnr() ~= vim.fn.winnr("l") do
                vim.cmd("wincmd l")
              end
              -- 在最右侧打开垂直分割窗口
              vim.cmd("vsplit " .. node.path)
              -- 移动到新窗口（现在是最右侧）
              vim.cmd("wincmd l")
              -- 设置窗口为固定缓冲区（Neovim 0.10+）
              if vim.fn.has("nvim-0.10") == 1 then
                vim.wo.winfixbuf = true
              else
                -- 对于旧版本，使用自动命令防止缓冲区切换
                local win_id = vim.api.nvim_get_current_win()
                local buf_id = vim.api.nvim_get_current_buf()
                vim.api.nvim_create_autocmd("BufLeave", {
                  callback = function()
                    if vim.api.nvim_win_is_valid(win_id) then
                      vim.api.nvim_win_set_buf(win_id, buf_id)
                    end
                  end,
                  buffer = buf_id,
                })
              end
            end
          end,
          desc = "Open in fixed vertical split on the right",
        },
        ["S"] = {
          function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              -- 移动到最底部窗口
              vim.cmd("wincmd j")
              while vim.fn.winnr() ~= vim.fn.winnr("j") do
                vim.cmd("wincmd j")
              end
              -- 在最底部打开水平分割窗口
              vim.cmd("split " .. node.path)
              -- 移动到新窗口（现在是最底部）
              vim.cmd("wincmd j")
              -- 设置窗口为固定缓冲区
              if vim.fn.has("nvim-0.10") == 1 then
                vim.wo.winfixbuf = true
              else
                local win_id = vim.api.nvim_get_current_win()
                local buf_id = vim.api.nvim_get_current_buf()
                vim.api.nvim_create_autocmd("BufLeave", {
                  callback = function()
                    if vim.api.nvim_win_is_valid(win_id) then
                      vim.api.nvim_win_set_buf(win_id, buf_id)
                    end
                  end,
                  buffer = buf_id,
                })
              end
            end
          end,
          desc = "Open in fixed horizontal split at bottom",
        },
        ["cn"] = {
          function(state)
            local node = state.tree:get_node()
            local filename = vim.fn.fnamemodify(node:get_id(), ":t")
            vim.fn.setreg("+", filename, "c")
            vim.notify("已复制文件名: " .. filename, vim.log.levels.INFO)
          end,
          desc = "Copy filename to clipboard",
        },
        ["cp"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
            vim.notify("已复制完整路径: " .. path, vim.log.levels.INFO)
          end,
          desc = "Copy path to clipboard",
        },
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
        ["u"] = {
          function(state)
            -- 获取当前根目录的上一层目录
            local current_root = state.path or vim.fn.getcwd()
            local parent = vim.fn.fnamemodify(current_root, ":h")

            -- 如果上层目录存在且不是当前目录，则切换到上层目录
            if parent and parent ~= current_root then
              require("neo-tree.command").execute({
                dir = parent,
                reveal = true,
                reveal_file = current_root  -- 定位到原来的目录
              })
            else
              vim.notify("已到达根目录", vim.log.levels.INFO)
            end
          end,
          desc = "Navigate to parent directory",
        },
        ["-"] = {
          function(state)
            -- 另一种实现方式：使用 - 键也可以切换到上层目录
            local current_root = state.path or vim.fn.getcwd()
            local parent = vim.fn.fnamemodify(current_root, ":h")

            if parent and parent ~= current_root then
              require("neo-tree.command").execute({
                dir = parent,
                reveal = true,
                reveal_file = current_root
              })
            else
              vim.notify("已到达根目录", vim.log.levels.INFO)
            end
          end,
          desc = "Go up to parent directory",
        },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
        },
      },
    },
  },
  config = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
