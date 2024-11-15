return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.inlay_hints = { enabled = false }
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    keys[#keys + 1] = {
      "<leader>ch",
      function()
        vim.lsp.buf.signature_help()
      end,
      mode = "n",
      desc = "Show Signature Help"
    }
    return opts
  end,
}
