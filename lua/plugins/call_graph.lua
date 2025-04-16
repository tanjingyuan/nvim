return {
  "ravenxrz/call-graph.nvim",
  opts = {
    log_level = "info",
    reuse_buf = true, -- 多次生成的call graph是否复用同一个buf
    auto_toggle_hl = true, -- 是否自动高亮
    hl_delay_ms = 200, -- 自动高亮间隔时间
    ref_call_max_depth = 3, -- 使用reference call生成graph时，最多搜索的深度
  },
}
