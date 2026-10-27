return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      no_italic = true,
      integrations = { blink_cmp = true, mason = true, snacks = true },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-macchiato" } },
}
