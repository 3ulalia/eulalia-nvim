if vim.g.did_load_lazygit_plugin then
  return
end
vim.g.did_load_lazygit_plugin = true

local lazygit = require('lazygit-nvim')

lazygit.setup {}

require('telescope').load_extension('lazygit')

vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', {desc = "Lazy[g][g]it"})
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('*', {clear = true}),
  callback = function()
    require('lazygit.utils').project_root_dir()
  end,
})
