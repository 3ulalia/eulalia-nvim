if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

-- Highlights unique characters for f/F and t/T motions
require('neo-tree').setup {
  close_if_last_window = true,
  hijack_netrw_behavior = "disabled"
}

vim.keymap.set("n", "<leader><Tab>", "<Cmd>Neotree toggle reveal<CR>")
