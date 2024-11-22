local M = {}

function M.setup()
  vim.cmd([[
      highlight MatchParen guifg=#fdf6e3 ctermbg=12 guibg=#839496
    ]])

  vim.cmd([[
  highlight PmenuSel guibg=#4CAF50 guifg=#ffffff
]])
end

return M
