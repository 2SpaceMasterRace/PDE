return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.icons_enabled = false
      opts.options.component_separators = ""
      opts.options.section_separators = ""
      opts.sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return mode:sub(1, 1)
            end,
          },
        },
        lualine_b = {},
        lualine_c = { { "filename", path = 0 } },
        lualine_x = {
          { "diagnostics", sections = { "error", "warn" }, symbols = { error = "E:", warn = "W:" } },
        },
        lualine_y = {},
        lualine_z = { "location" },
      }
      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
      opts.extensions = {}
    end,
  },
}
