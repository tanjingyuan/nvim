return {
  "ojroques/vim-oscyank",
  event = "VeryLazy",
  config = function()
    -- 其他配置...
    vim.g.oscyank_max_length = 0
    vim.g.oscyank_silent = 0
    vim.g.oscyank_trim = 0
    vim.g.oscyank_osc52 = "\x1b]52;c;%s\x07"
    -- Lua 版本的代码
    if not vim.fn.has("nvim") and not vim.fn.has("clipboard_working") then
      local vim_osc_yank_post_registers = { "", "+", "*" }

      local function vim_osc_yank_post_callback(event)
        if event.operator == "y" and vim.tbl_contains(vim_osc_yank_post_registers, event.regname) then
          vim.fn["OSCYankRegister"](event.regname)
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("VimOSCYankPost", { clear = true }),
        callback = function()
          vim_osc_yank_post_callback(vim.v.event)
        end,
      })
    end

    -- 其他 Lua 配置...
  end,
}
