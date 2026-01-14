if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

-- Highlights unique characters for f/F and t/T motions
require('neotree').setup {
  close_if_last_window = true,
}
