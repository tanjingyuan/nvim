return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      keymap = {
        fzf = {
          ["ctrl-n"] = "donw",
          ["ctrl-p"] = "up",
          -- ["alt-n"] = "next-history",
          -- ["alt-p"] = "previous-history",
        },
      },
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        ["--cycle"] = true,
        ["--highlight-line"] = true, -- fzf >= v0.53
        ["--info"] = "inline-right", -- fzf < v0.42 = "inline"
      },
    })
  end,
  config = function()
    -- older fzf-lua expects this helper; ensure stub exists on nightly builds
    local stub = function() end

    local ok_ts_mod, ts_mod = pcall(require, "vim.treesitter")
    if ok_ts_mod and ts_mod and not ts_mod.close_leaked_contexts then
      ts_mod.close_leaked_contexts = stub
    end
    if vim.treesitter and not vim.treesitter.close_leaked_contexts then
      vim.treesitter.close_leaked_contexts = stub
    end

    local function set_ctx_stubs()
      local ok_render, render = pcall(require, "treesitter-context.render")
      if ok_render and render then
        if type(render.close_leaked_contexts) ~= "function" then
          render.close_leaked_contexts = stub
        end
        if type(render.open) ~= "function" then
          render.open = function() end
        end
      end
      local ok_ctx, ctx_mod = pcall(require, "treesitter-context.context")
      if ok_ctx and ctx_mod then
        if type(ctx_mod.get) ~= "function" then
          ctx_mod.get = function()
            return nil
          end
        else
          local origin_get = ctx_mod.get
          ctx_mod.get = function(winid, ...)
            local target_winid = winid
            if select("#", ...) >= 1 then
              target_winid = select(1, ...)
            end
            -- 更严格的窗口有效性检查
            if target_winid and not vim.api.nvim_win_is_valid(target_winid) then
              return nil
            end
            -- 用 pcall 包裹原始调用，捕获任何运行时错误
            local ok, ranges, lines = pcall(origin_get, target_winid)
            if not ok then
              return nil
            end
            return ranges, lines
          end
        end
      end
    end

    set_ctx_stubs()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = set_ctx_stubs,
    })

    require("fzf-lua").setup({
      "telescope",
    })
  end,
}
