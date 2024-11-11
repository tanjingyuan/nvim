return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "HiPhish/nvim-ts-rainbow2",
    "andymass/vim-matchup", -- 添加 vim-matchup 插件
  },
  opts = function(_, opts)
    -- Treesitter 配置
    opts.highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }
    opts.indent = {
      enable = true,
    }
    opts.matchup = {
      enable = true, -- 启用 treesitter 的 matchup 集成
    }
    opts.rainbow = {
      enable = true,
      query = "rainbow-parens",
      strategy = require("ts-rainbow").strategy.global,
      hlgroups = {
        "TSRainbowRed",
        "TSRainbowYellow",
        "TSRainbowBlue",
        "TSRainbowOrange",
        "TSRainbowGreen",
        "TSRainbowViolet",
        "TSRainbowCyan",
      },
    }

    -- vim-matchup 配置
    vim.g.matchup_matchparen_offscreen = { method = "popup" }

    -- 高亮配置
    -- vim.cmd([[
    --   highlight MatchParen cterm=bold ctermbg=red guibg=lightyellow
    -- ]])
    -- vim.cmd([[
    --   highlight MatchParen cterm=bold guibg=lightyellow
    -- ]])
    vim.cmd([[
      highlight MatchParen cterm=NONE,bold gui=NONE,bold ctermfg=15 guifg=#fdf6e3 ctermbg=12 guibg=#839496
    ]])
  end,
}
