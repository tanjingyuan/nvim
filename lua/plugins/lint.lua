return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  opts = {
    -- 增加 TextChanged/InsertLeave 让 prototxt 这类配置改动时能更“实时”看到错误
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "TextChangedI" },
    linters_by_ft = {
      cmake = { "cmakelint" },
      prototxt = { "protoc_unittest_args_textproto" },
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["*"] = { "typos" },
    },
    linters = {
      protoc_unittest_args_textproto = {
        condition = function(ctx)
          local proto_file =
            vim.fs.find({ "unittests/test_util/proto/unittest_args.proto" }, { path = ctx.filename, upward = true })[1]
          return proto_file ~= nil
        end,
        cmd = "protoc",
        stdin = true,
        ignore_exitcode = true,
        stream = "stderr",
        args = {
          "-I",
          function()
            local filename = vim.api.nvim_buf_get_name(0)
            local proto_file =
              vim.fs.find({ "unittests/test_util/proto/unittest_args.proto" }, { path = filename, upward = true })[1]
            return proto_file and vim.fs.dirname(proto_file) or ""
          end,
          "--encode=senseAD.perception.camera.SAPDemoParameter",
          "unittest_args.proto",
        },
        parser = function(output)
          local diagnostics = {}
          if not output or output == "" then
            return diagnostics
          end

          for _, line in ipairs(vim.split(output, "\n", { plain = true, trimempty = true })) do
            local file, lnum, col, msg = line:match("^([^:]+):(%d+):(%d+):%s*(.+)$")
            if file and lnum and col and msg then
              diagnostics[#diagnostics + 1] = {
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                message = msg,
                severity = vim.diagnostic.severity.ERROR,
                source = "protoc(textproto)",
              }
            end
          end

          return diagnostics
        end,
      },
    },
  },
}
