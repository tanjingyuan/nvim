return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })
    opts.inlay_hints = { enabled = false }
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    keys[#keys + 1] = {
      "<leader>ch",
      function()
        vim.lsp.buf.signature_help()
      end,
      mode = "n",
      desc = "Show Signature Help",
    }

    -- 修复带注释的文本编辑导致的重命名错误
    keys[#keys + 1] = {
      "<leader>cr",
      function()
        -- 使用自定义的重命名函数处理带注释的文本编辑
        local params = vim.lsp.util.make_position_params()
        params.newName = vim.fn.input("New Name: ", vim.fn.expand("<cword>"))
        if params.newName and #params.newName > 0 then
          vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, config)
            if err then
              vim.notify("Rename failed: " .. vim.inspect(err), vim.log.levels.ERROR)
              return
            end
            if not result then
              vim.notify("No rename changes", vim.log.levels.INFO)
              return
            end
            -- 处理工作区编辑，忽略注释
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
        end
      end,
      desc = "Rename",
    }

    return opts
  end,
}
