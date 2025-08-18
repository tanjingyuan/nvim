local M = {}

function M.setup()
  vim.cmd([[
      highlight MatchParen guifg=#ffb6c1 guibg=#ff5555 cterm=bold gui=bold
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

  -- 设置当前行行号为醒目的橙色
  vim.cmd("highlight CursorLineNr guifg=#ff8800 gui=bold")

  -- 可选：设置普通行号颜色为稍微暗一些的颜色以形成对比
  vim.cmd("highlight LineNr guifg=#6b7280")

  -- 可选：设置当前行颜色为白色或者浅灰色
  -- vim.cmd("highlight CursorLine guibg=#45475a")
  vim.cmd("highlight CursorLine guibg=#2e3440")
end

return M
