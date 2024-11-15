-- bootstrap lazy.nvim, LazyVim and your pluginsvim
require("config.lazy")

vim.o.termguicolors = true

local system = require("utils.system")
local clipboard = require("utils.clipboard")
local check_module = require("utils.check")

clipboard.setup()
check_module.check()
system.setup()
