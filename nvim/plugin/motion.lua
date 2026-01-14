-- precognition

if vim.g.did_load_precognition_plugin then
  return
end
vim.g.did_load_precognition_plugin = true

require('precognition').setup {}

-- ^ precognition

 -- treewalker

 require('treewalker').setup {
 }

 -- movement
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })

-- swapping
vim.keymap.set('n', '<C-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true })
vim.keymap.set('n', '<C-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true })
vim.keymap.set('n', '<C-S-h>', '<cmd>Treewalker SwapLeft<cr>', { silent = true })
vim.keymap.set('n', '<C-S-l>', '<cmd>Treewalker SwapRight<cr>', { silent = true })

-- ^ treewalker

 -- leap

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')

vim.keymap.set({'x', 'o'}, 'R',  function ()
  require('leap.treesitter').select {
    opts = require('leap.user').with_traversal_keys('R', 'r')
  }
end)

-- Highly recommended: define a preview filter to reduce visual noise
-- and the blinking effect after the first keypress (see
-- `:h leap.opts.preview`).
-- For example, skip preview if the first character of the match is
-- whitespace or is in the middle of an alphabetic word:
require('leap').opts.preview = function (ch0, ch1, ch2)
  return not (
    ch1:match('%s')
    or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  )
end

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

-- Automatic paste after remote yank operations:
vim.api.nvim_create_autocmd('User', {
  pattern = 'RemoteOperationDone',
  group = vim.api.nvim_create_augroup('LeapRemote', {}),
  callback = function (event)
    if vim.v.operator == 'y' and event.data.register == '"' then
      vim.cmd('normal! p')
    end
  end,
})

-- treesitter integration
vim.keymap.set({'x', 'o'}, 'R',  function ()
  require('leap.treesitter').select {
    -- To increase/decrease the selection in a clever-f-like manner,
    -- with the trigger key itself (vRRRRrr...). The default keys
    -- (<enter>/<backspace>) also work, so feel free to skip this.
    opts = require('leap.user').with_traversal_keys('R', 'r')
  }
end)

-- remote actions
vim.keymap.set({'n', 'x', 'o'}, 'gs', function ()
  require('leap.remote').action()
end)

-- icing 1: automatic paste after yanking
vim.api.nvim_create_autocmd('User', {
  pattern = 'RemoteOperationDone',
  group = vim.api.nvim_create_augroup('LeapRemote', {}),
  callback = function (event)
    -- Do not paste if some special register was in use.
    if vim.v.operator == 'y' and event.data.register == '"' then
      vim.cmd('normal! p')
    end
  end,
})

-- icing 2: feeding input
-- Trigger visual selection right away, so that you can `gs{leap}apy`:
vim.keymap.set({'n', 'o'}, 'gs', function ()
  require('leap.remote').action { input = 'v' }
end)

-- Create remote versions of all a/i text objects by inserting `r` into
-- the middle (`iw` becomes `irw`, etc.).
for _, ai in ipairs { 'a', 'i' } do
  vim.keymap.set({ 'x', 'o' }, ai .. 'r', function ()
    -- A trick to avoid having to create separate mappings for each text
    -- object: when entering `ar`/`ir`, consume the next character, and
    -- create the input from that character concatenated to `a`/`i`.
    local ok, ch = pcall(vim.fn.getcharstr)  -- pcall for handling <C-c>
    if not ok or ch == vim.keycode('<esc>') then return end
    require('leap.remote').action { input = ai .. ch }
  end)
end

-- jump to off-screen areas
vim.keymap.set({'n', 'o'}, 'g/', function ()
  require('leap.remote').action { jumper = '/' }
end)
vim.keymap.set({'n', 'o'}, 'g?', function ()
  require('leap.remote').action { jumper = '?' }
end)

-- ^ leap
