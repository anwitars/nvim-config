return {
  'davvid/telescope-git-grep.nvim',
  config = function()
    require('telescope').load_extension 'git_grep'
  end,
}
