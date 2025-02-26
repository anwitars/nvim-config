local config = {
  options = {
    theme = 'auto',
    section_separators = ' ',
    component_separators = ' ',
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {
      'filename',
      'diff',
    },
    lualine_c = { {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
    } },
    lualine_x = {},
    lualine_y = {
      {
        function()
          local ok, gitblame = pcall(require, 'gitblame')
          if not ok then
            return ''
          end

          return gitblame.get_current_blame_text()
        end,
        condition = function()
          local ok, _ = pcall(require, 'gitblame')
          if not ok then
            return false
          end

          return vim.g.gitblame_enabled
        end,
      },
    },
    lualine_z = { 'location' },
  },
  winbar = {
    lualine_a = {
      {
        function()
          local navic = require 'nvim-navic'

          if not navic.is_available() then
            return ''
          end

          local location = navic.get_location()
          return location ~= '' and location or ' '
        end,
        condition = function()
          local ok, _ = pcall(require, 'nvim-navic')
          if not ok then
            return false
          end

          return true
        end,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup(config)
  end,
}
