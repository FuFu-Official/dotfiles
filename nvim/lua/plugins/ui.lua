return {
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   opts = {
  --     transparent_mode = true,
  --   },
  -- },
  -- {
  --   "catppuccin/nvim",
  --   opts = {
  --     flavour = "mocha",
  --     transparent_background = false,
  --     auto_integrations = true,
  --   },
  -- },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      styles = {
        transparency = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
  {
    "eandrju/cellular-automaton.nvim",
  },
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {
      insert_mode = true,
      floating = false,
      disabled_filetypes = { "NvimTree", "lazy", "terminal", "snacks_terminal" },
    },
  },
}
