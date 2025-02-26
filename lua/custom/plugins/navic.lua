return {
  'SmiteshP/nvim-navic',
  event = 'BufRead',
  config = function()
    require('nvim-navic').setup {
      lsp = {
        auto_attach = true,
      },
    }
  end,
  -- opts = {
  --   lsp = {
  --     auto_attach = true,
  --   },
  -- },
}
