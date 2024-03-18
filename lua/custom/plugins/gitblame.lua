return {
  'f-person/git-blame.nvim',
  event = 'BufRead',
  opts = {
    enabled = true,
    display_virtual_text = false,
    message_template = '<author> | <date>',
    date_format = '%r',
    delay = 0,
  },
}
