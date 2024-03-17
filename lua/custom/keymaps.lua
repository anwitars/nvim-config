local km = vim.keymap

M = {}

-- jump windows with arrows
km.set('n', '<C-Up>', '<C-w>k', { noremap = true, silent = true })
km.set('n', '<C-Down>', '<C-w>j', { noremap = true, silent = true })
km.set('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })
km.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- resize windows with arrows
km.set('n', '<C-S-Up>', ':resize +2<CR>', { noremap = true, silent = true })
km.set('n', '<C-S-Down>', ':resize -2<CR>', { noremap = true, silent = true })
km.set('n', '<C-S-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
km.set('n', '<C-S-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- separate system clipboard from vim clipboard (but have both)
km.set('x', '<C-p>', '"_dP')
km.set('v', '<C-y>', '"+y')

km.set('n', 'Q', '<nop>')

-- km.set('n', '<leader>fp', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- chmod current file
local chmod = function()
  local perms = vim.fn.input 'Permissions: '
  if perms == '' then
    return
  end
  local cmd = 'silent !chmod ' .. perms .. ' %'
  vim.cmd(cmd)
end
-- km.set('n', '<leader>sp', chmod)

-- which-key-compatible mappings

-- this function's goal is to turn my keymap table into a which-key
-- compatible table, and also register the contained keymaps
-- the syntax:
-- {
--      key = { "description", "command" },
--      key2 = {
--          name = "section name",
--          key3 = { "description", "command" },
--      },
-- }
Register_keymaps = function(keymaps, previous_keys)
  local keys = previous_keys or ''
  local result = {}

  if not keymaps.name then
    local description = nil
    local mapping = nil

    for index, value in ipairs(keymaps) do
      if index == 1 then
        description = value
      elseif index == 2 then
        mapping = value
      end
    end

    if description then
      km.set('n', '<leader>' .. keys, mapping)
      return { description }
    end
  end

  for key, mapping in pairs(keymaps) do
    if type(key) == 'number' then
      return { mapping }
    end
    if type(mapping) == 'table' then
      result[key] = Register_keymaps(mapping, keys .. key)
    elseif type(mapping) == 'string' then
      result[key] = mapping
    else
      local description = mapping[1]
      result[key] = { description }
    end
  end

  return result
end

local delete_buffer_except_current = function()
  local current_buffer = vim.fn.bufnr()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  for _, buffer in ipairs(buffers) do
    if buffer.bufnr ~= current_buffer then
      vim.cmd('silent! bdelete ' .. buffer.bufnr)
    end
  end
end

local delete_all_buffers = function()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  for _, buffer in ipairs(buffers) do
    vim.cmd('silent! bdelete ' .. buffer.bufnr)
  end
end

Anwitars_keymaps = {
  f = {
    name = 'file',
    f = { 'Find file', '<cmd>Telescope find_files<CR>' },
    g = { 'Find file in project', '<cmd>Telescope git_files<CR>' },
    w = { 'Find text in file', '<cmd>Telescope live_grep<CR>' },
    p = { 'Peek file path', "<cmd>echo expand('%')<CR>" },
    d = { 'Find git diff', '<cmd>Telescope git_status<CR>' },
    b = { 'Find buffer', '<cmd>Telescope buffers<CR>' },
    c = { 'Copy file path to system clipboard', "<cmd>let @+ = expand('%')<CR>" },
  },
  y = { 'Copy to system clipboard', '"+y' },
  Y = { 'Copy line to system clipboard', '"+Y' },
  u = { 'Toggle undo tree', '<cmd>UndotreeToggle<CR>' },
  l = {
    name = 'LSP',
    d = {
      name = 'diagnostics',
      l = { 'Line diagnostics', '<cmd>lua vim.diagnostic.open_float()<CR>' },
      n = { 'Next diagnostic', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
      p = { 'Previous diagnostic', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
      b = { 'Buffer diagnostics', '<cmd>TroubleToggle document_diagnostics<CR>' },
    },
    g = {
      name = 'goto',
      d = { 'Goto definition', '<cmd>Telescope lsp_definitions<CR>' },
      r = { 'Goto references', '<cmd>Telescope lsp_references<CR>' },
      i = { 'Goto implementation', '<cmd>Telescope lsp_implementations<CR>' },
    },
    f = { 'Format file', '<cmd>lua vim.lsp.buf.format()<CR>' },
    a = { 'Code action', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
    r = { 'Rename', '<cmd>lua vim.lsp.buf.rename()<CR>' },
    F = {
      name = 'Format using commands',
      b = { 'Black', '<cmd>silent !black %<CR>' },
      p = { 'Prettier', '<cmd>silent %!prettier --write %<CR>' },
    },
  },
  g = {
    name = 'git',
    s = { 'Git status', vim.cmd.Git },
    b = { 'Git blame', '<cmd>Git blame<CR>' },
    B = { 'Copy commit hash for this line', '<cmd>GitBlameCopySHA<CR>' },
    d = { 'Git diff to HEAD', '<cmd>Gdiff<CR>' },
  },
  b = {
    name = 'buffer',
    d = { 'Delete buffer', '<cmd>bd<CR>' },
    D = { 'Delete buffer (force)', '<cmd>bd!<CR>' },
    n = { 'Next buffer', '<cmd>bn<CR>' },
    p = { 'Previous buffer', '<cmd>bp<CR>' },
    s = {
      name = 'split',
      v = { 'Split vertically', '<cmd>vs<CR>' },
      h = { 'Split horizontally', '<cmd>sp<CR>' },
    },
    c = { 'Delete buffers except current', delete_buffer_except_current },
    C = { 'Delete all buffers', delete_all_buffers },
  },
  t = {
    name = 'tools',
    t = { 'Toggle terminal', '<cmd>ToggleTerm<CR>' },
    C = {
      name = 'Copilot',
      e = { 'Enable', '<cmd>Copilot enable<CR>' },
      d = { 'Disable', '<cmd>Copilot disable<CR>' },
      r = { 'Restart', '<cmd>Copilot restart<CR>' },
      c = { 'Results', '<cmd>Copilot<CR>' },
      s = { 'Status', '<cmd>Copilot status<CR>' },
    },
    c = {
      name = 'Colorizer',
      t = { 'Toggle', '<cmd>ColorizerToggle<CR>' },
    },
  },
  o = {
    name = 'Open',
    d = { 'Open current buffer directory', '<cmd>e %:h<CR>' },
  },
}

M.remappings = Register_keymaps(Anwitars_keymaps)

require('which-key').register(M.remappings, { prefix = '<leader>' })

return M
