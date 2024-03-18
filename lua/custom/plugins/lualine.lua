local config = {
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = '',
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
