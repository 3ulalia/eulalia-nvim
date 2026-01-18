if vim.g.did_load_eyeliner_plugin then
  return
end
vim.g.did_load_eyeliner_plugin = true

-- Highlights unique characters for f/F and t/T motions
require('eyeliner').setup {
  highlight_on_key = true, -- show highlights only after key press
  dim = true, -- dim all other characters
}

require('todo-comments').setup()

vim.keymap.set('n', '<leader>qt', '<cmd>TodoQuickFix<cr>', { desc = '[q]uickfix: open [t]odos' })
vim.keymap.set('n', '<leader>lt', '<cmd>TodoLocList<cr>', {  desc = '[l]oclist: open [t]odos'  })
vim.keymap.set('n', '<leader>fo', '<cmd>TodoTelescope<cr>', {desc = '[f]ind tod[o]s with telescope' })

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●"
  },
  severity_sort = true,
}
