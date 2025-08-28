local M = {}

-- 状态变量，跟踪高亮是否启用
M.enabled = false

-- 常驻高亮
function M.dameon_highlights()
  -- 设置当前行行号为醒目的橙色
  vim.cmd("highlight CursorLineNr guifg=#ff8800 gui=bold")

  -- 可选：设置普通行号颜色为稍微暗一些的颜色以形成对比
  vim.cmd("highlight LineNr guifg=#6b7280") --中灰色
  vim.cmd("highlight CursorLine guibg=#2e3440") --深灰色

  if vim.g.colors_name == "everforest" then
    vim.cmd("highlight IlluminatedWordText guibg=#425047") -- 暗绿色背景
    vim.cmd("highlight IlluminatedWordRead guibg=#425047") -- 暗绿色背景
    vim.cmd("highlight IlluminatedWordWrite guibg=#504945") -- 稍暗的棕色背景

    vim.cmd("highlight Visual guibg=#6c6f52") --橄榄黄
    -- vim.cmd("highlight Visual guibg=#445349 guifg=NONE") --绿灰色
  elseif vim.g.colors_name == "catppuccin-mocha" then
    vim.cmd("highlight Visual guibg=#135564") --青色
  else
  end
end

-- 应用高亮设置
function M.apply_highlights()
  M.dameon_highlights()
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
end

-- 清除自定义高亮设置，保留主题原本设置
function M.clear_highlights()
  -- 清除自动命令
  vim.cmd([[
augroup BracketHighlight
  autocmd!
augroup END
]])

  -- 清除匹配高亮
  vim.cmd("match")

  -- 清除我们的自定义高亮组
  vim.cmd("highlight clear SelectedBracket")

  -- 恢复主题的默认高亮设置（通过重新加载颜色方案）
  local colorscheme = vim.g.colors_name
  if colorscheme then
    vim.cmd("colorscheme " .. colorscheme)
  end
end

-- 切换高亮功能
function M.toggle()
  if M.enabled then
    M.clear_highlights()
    M.enabled = false
    M.dameon_highlights()
    vim.notify("自定义高亮已禁用", vim.log.levels.INFO)
  else
    M.apply_highlights()
    M.enabled = true
    vim.notify("自定义高亮已启用", vim.log.levels.INFO)
  end
end

function M.setup()
  M.dameon_highlights()
  if M.enabled then
    M.apply_highlights()
  end
end

return M
