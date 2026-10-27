return {
  {
    "nvim-mini/mini.snippets",
    opts = {
      expand = {
        insert = function(snippet)
          return require("mini.snippets").default_insert(snippet, {
            empty_tabstop = "",
            empty_tabstop_final = "",
          })
        end,
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      signature = {
        enabled = true,
        trigger = { show_on_insert = true, show_on_accept = true },
        window = { border = "rounded", show_documentation = true, max_width = 65, max_height = 10 },
      },
      fuzzy = {
        sorts = {
          function(a, b)
            local snippet_kind = vim.lsp.protocol.CompletionItemKind.Snippet
            local a_snippet = a.source_id == "snippets" or a.kind == snippet_kind
            local b_snippet = b.source_id == "snippets" or b.kind == snippet_kind
            if a_snippet ~= b_snippet then
              return a_snippet
            end
          end,
          "score",
          "sort_text",
        },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = { border = "rounded", max_width = 65, max_height = 12 },
        },
        menu = { border = "rounded", auto_show = true },
      },
      keymap = {
        preset = "none",
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },
}
