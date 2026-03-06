return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].capabilities = vim.tbl_deep_extend("force", opts.servers["*"].capabilities or {}, {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })
    opts.inlay_hints = { enabled = false }

    -- 启用 shell 的 LSP（bash-language-server）
    -- 兼容“单文件/非 git 目录”：找不到 root marker 时回退到文件所在目录
    opts.servers.bashls = vim.tbl_deep_extend("force", opts.servers.bashls or {}, {
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local ok, util = pcall(require, "lspconfig.util")
        local root = ok and util.root_pattern(".git")(fname) or nil
        on_dir(root or vim.fs.dirname(fname))
      end,
    })

    opts.servers["*"].keys = opts.servers["*"].keys or {}
    local keys = opts.servers["*"].keys

    keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    keys[#keys + 1] = { "<leader>ch", vim.lsp.buf.signature_help, desc = "Show Signature Help" }

    -- 修复带注释的文本编辑导致的重命名错误
    keys[#keys + 1] = {
      "<leader>cr",
      function()
        local params = vim.lsp.util.make_position_params()
        params.newName = vim.fn.input("New Name: ", vim.fn.expand("<cword>"))
        if not (params.newName and #params.newName > 0) then
          return
        end

        vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, _)
          if err then
            vim.notify("Rename failed: " .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end
          if not result then
            vim.notify("No rename changes", vim.log.levels.INFO)
            return
          end

          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if result.documentChanges then
            for _, change in pairs(result.documentChanges) do
              if change.edits then
                for _, edit in pairs(change.edits) do
                  if edit.annotationId then
                    edit.annotationId = nil
                  end
                end
              end
            end
          elseif result.changes then
            for _, edits in pairs(result.changes) do
              for _, edit in pairs(edits) do
                if edit.annotationId then
                  edit.annotationId = nil
                end
              end
            end
          end

          vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
        end)
      end,
      desc = "Rename",
    }

    return opts
  end,
}
