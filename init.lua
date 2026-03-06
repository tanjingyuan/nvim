-- bootstrap lazy.nvim, LazyVim and your pluginsvim
require("config.lazy")
vim.keymap.set({ "n", "i", "x" }, "<C-s>", "<cmd>silent update<cr><esc>", { desc = "Save File" })

local system = require("utils.system")
local clipboard = require("utils.clipboard")
local check_module = require("utils.check")
local highlight = require("utils.highlight")
local vendor = require("utils.vendor")

clipboard.setup()
check_module.check()
system.setup()
highlight.setup()
vendor.setup()
