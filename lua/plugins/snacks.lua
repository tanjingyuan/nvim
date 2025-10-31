return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local projects_utils = require("utils.projects")
    local picker_util = require("snacks.picker.util")

    local function manual_projects_finder(_, _)
      local projects = projects_utils.load_projects()
      return function(cb)
        for _, path in ipairs(projects) do
          cb({ file = path, text = path, dir = true })
        end
      end
    end

    -- 仪表盘标题
    opts.dashboard = opts.dashboard or {}
    opts.dashboard.preset = opts.dashboard.preset or {}
    opts.dashboard.preset.header = [[
      _______ _________
      |_   _| | \ \ / /
        | |_  | |\ V / 
        | | |_| | | |  
        |_|\___/  |_|  
                      
 ]]

    -- 禁用平滑滚动
    opts.scroll = vim.tbl_deep_extend("force", opts.scroll or {}, { enabled = false })

    -- 提示浮窗样式
    opts.notifier = vim.tbl_deep_extend("force", opts.notifier or {}, {
      enabled = true,
      style = "compact",
      top_down = true,
    })

    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}

    local projects_source = vim.tbl_deep_extend("force", opts.picker.sources.projects or {}, {
      focus = "list",
      finder = manual_projects_finder,
      format = "file",
    })

    -- 仅展示手动保存的项目
    projects_source.dev = nil
    projects_source.patterns = nil
    projects_source.recent = nil
    -- 自定义确认动作：切换到选中的项目目录
    projects_source.confirm = function(picker, item)
      if not item or not item.file then
        return
      end
      picker:close()
      local dir = item.file
      -- 切换到项目目录
      vim.cmd("cd " .. vim.fn.fnameescape(dir))

      -- 更新 Neotree 到新目录
      local ok, neo_cmd = pcall(require, "neo-tree.command")
      if ok then
        -- 使用 Neotree API 直接切换到新目录
        neo_cmd.execute({
          action = "focus",
          source = "filesystem",
          position = "left",
          dir = dir,
          reveal = false,
        })
      else
        -- 如果 Neotree 模块加载失败，使用命令
        vim.cmd("Neotree filesystem left dir=" .. vim.fn.fnameescape(dir))
      end

      vim.notify("✓ Switched to project: " .. vim.fn.fnamemodify(dir, ":t"), vim.log.levels.INFO)
    end
    projects_source.matcher = nil
    projects_source.sort = nil

    projects_source.actions = projects_source.actions or {}
    ---@param picker snacks.Picker
    projects_source.actions.delete_project = function(picker)
      local item = picker:current()
      if not item or not item.file then
        vim.notify("⚠ No project selected!", vim.log.levels.WARN)
        return
      end

      local project_path = picker_util.path(item) or item.file
      if not project_path or project_path == "" then
        vim.notify("⚠ Failed to resolve project path!", vim.log.levels.ERROR)
        return
      end

      local project_name = vim.fn.fnamemodify(project_path, ":t")
      local choice =
        vim.fn.confirm("Delete project '" .. project_name .. "' from list?\n" .. project_path, "&Yes\n&No", 2)

      if choice == 1 then
        local proj_utils = require("utils.projects")
        local ok = proj_utils.remove_project(project_path)
        if ok then
          vim.notify("✓ Project '" .. project_name .. "' removed!", vim.log.levels.INFO)
          -- 不需要手动更新 projects，因为 finder 会动态加载
          picker:close()
          vim.schedule(function()
            Snacks.picker.projects()
          end)
        else
          vim.notify("⚠ Failed to remove project! Path not found in saved list.", vim.log.levels.WARN)
        end
      end
    end

    projects_source.win = projects_source.win or {}
    projects_source.win.input = vim.tbl_deep_extend("force", projects_source.win.input or {}, {
      keys = vim.tbl_deep_extend("force", {}, projects_source.win.input and projects_source.win.input.keys or {}, {
        ["<c-d>"] = { "delete_project", mode = { "n", "i" }, desc = "Delete project" },
      }),
    })
    projects_source.win.list = vim.tbl_deep_extend("force", projects_source.win.list or {}, {
      keys = vim.tbl_deep_extend("force", {}, projects_source.win.list and projects_source.win.list.keys or {}, {
        ["<c-d>"] = { "delete_project", mode = { "n" }, desc = "Delete project" },
      }),
    })

    opts.picker.sources.projects = projects_source

    return opts
  end,
  keys = {
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
  },
}
