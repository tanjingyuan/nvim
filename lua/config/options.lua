-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.termguicolors = true
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.lazyvim_picker = "snacks"
-- 禁止 LazyVim 默认的 unnamedplus，由 utils/clipboard.lua 控制剪贴板行为
vim.opt.clipboard = ""
-- vim.opt.listchars = { tab = '▸ ', trail = '·', space = '·' }

-- protobuf text format (e.g. *.prototxt)
vim.filetype.add({
  extension = {
    prototxt = "prototxt",
    pbtxt = "prototxt",
    textproto = "prototxt",
    csv = "csv",
    tsv = "tsv",
  },
  pattern = {
    [".*%.CSV"] = "csv",
    [".*%.TSV"] = "tsv",
    [".*%.MD"] = "markdown",
    [".*%.JSON"] = "json",
    [".*%.YAML"] = "yaml",
    [".*%.YML"] = "yaml",
    [".*%.TOML"] = "toml",
    [".*%.LUA"] = "lua",
    [".*%.PY"] = "python",
    [".*%.SH"] = "sh",
  },
})

local function configure_diagnostics()
  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
      source = "if_many",
      prefix = "●",
      spacing = 2,
    },
    float = {
      border = "rounded",
      source = "always",
    },
  })

  local signs = { Error = "E", Warn = "W", Info = "I", Hint = "H" }
  for name, text in pairs(signs) do
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = text, texthl = hl, numhl = "DiagnosticLineNr" .. name })
  end
end

configure_diagnostics()

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("UserDiagnosticsConfig", { clear = true }),
  pattern = "LazyVimStarted",
  callback = function()
    vim.schedule(configure_diagnostics)
  end,
  desc = "Make diagnostics more visible",
})
