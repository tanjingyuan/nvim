return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    nes = { enabled = false },
    copilot = { status = { enabled = false } },
    cli = {
      tools = {
        codex = { cmd = { "codex" } },
      },
      win = { layout = "right" },
      prompts = {
        explain = "请用中文解释下面的代码：先说明它的作用，再解释输入输出和关键步骤。只分析，不修改文件。\n{file}\n{selection|position}",
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    -- Seed the source window before Sidekick's scheduled WinEnter tracking starts.
    vim.w.sidekick_visit = vim.uv.hrtime()
  end,
  keys = {
    { "<leader>a", nil, desc = "AI/Codex", mode = { "n", "x" } },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Toggle Codex",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").focus({ name = "codex" })
      end,
      desc = "Focus Codex",
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{file}", focus = true })
      end,
      desc = "Send File to Codex",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ name = "codex", msg = "{file}\n{selection}", focus = true })
      end,
      mode = "x",
      desc = "Send Selection to Codex",
    },
    {
      "<leader>ae",
      function()
        require("sidekick.cli").send({ name = "codex", prompt = "explain", focus = true })
      end,
      mode = { "n", "x" },
      desc = "Explain Code with Codex",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").hide({ name = "codex" })
      end,
      desc = "Hide Codex",
    },
  },
}
