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

  -- 设置 visual 模式下选中的背景高亮色
  vim.cmd("highlight Visual guibg=#135564")

  -- 设置光标的颜色默认为拉姆的发(fà)色
  vim.cmd("highlight Cursor gui=NONE guifg=bg guibg=#ffb6c1")
end

return M
