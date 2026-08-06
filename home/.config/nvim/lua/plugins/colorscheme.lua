return {
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    name = 'rose-pine',

    config = function()
      require('rose-pine').setup({
        dark_variant = 'moon',
        dim_inactive_windows = false,
        extend_background_behind_borders = false,

        styles = {
          italic = false,
          transparency = vim.uv.os_uname().sysname == 'Darwin'
            or string.find(vim.uv.os_uname().sysname, 'Windows') ~= nil
            or string.find(vim.uv.os_uname().release, 'WSL') ~= nil,
        },
      })

      vim.cmd('colorscheme rose-pine')

      local palette = require('rose-pine.palette')

      -- Make line numbers visible
      vim.api.nvim_set_hl(0, 'LineNr', {
        fg = palette.muted,
      })

      vim.api.nvim_set_hl(0, 'CursorLineNr', {
        fg = palette.text,
        bold = true,
      })

      -- Make the dimmed directory path in the Snacks picker readable
      vim.api.nvim_set_hl(0, 'SnacksPickerDir', {
        fg = palette.subtle,
      })
    end,
  },
}
