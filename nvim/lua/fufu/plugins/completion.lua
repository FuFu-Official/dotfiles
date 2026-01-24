return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<C-h>"] = {
          function(cmp)
            cmp.scroll_documentation_down(4)
          end,
        },
        ["<C-l>"] = {
          function(cmp)
            cmp.scroll_documentation_up(4)
          end,
        },
        -- C-space: Open menu or open docs if already open
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true },
        -- ghost_text = { enabled = true },
        -- menu = {
        --   direction_priority = function()
        --     local ctx = require("blink.cmp").get_context()
        --     local item = require("blink.cmp").get_selected_item()
        --     if ctx == nil or item == nil then
        --       return { "s", "n" }
        --     end
        --
        --     local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
        --     local is_multi_line = item_text:find("\n") ~= nil
        --
        --     -- after showing the menu upwards, we want to maintain that direction
        --     -- until we re-open the menu, so store the context id in a global variable
        --     if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
        --       vim.g.blink_cmp_upwards_ctx_id = ctx.id
        --       return { "n", "s" }
        --     end
        --     return { "s", "n" }
        --   end,
        -- },
      },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
