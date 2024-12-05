local M = {}

function M.setup()
  vim.cmd([[
      highlight MatchParen guifg=#fdf6e3 ctermbg=12 guibg=#839496
    ]])

  vim.cmd([[
  highlight PmenuSel guibg=#4CAF50 guifg=#ffffff
]])

  vim.cmd([[
  highlight SelectedBracket guibg=#ff5555 guifg=#f8f8f2
]])

  -- 设置自动命令
  vim.cmd([[
augroup BracketHighlight
  autocmd!
  autocmd CursorMoved * silent! execute "match SelectedBracket /\\%#[({}\\[\\])]/"
augroup END
 ]])
end

return M
