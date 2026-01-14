if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

-- Highlights unique characters for f/F and t/T motions
require('neo-tree').setup {
  close_if_last_window = true,
}

vim.keymap.set("n", "<leader><Tab>", "<Cmd>Neotree toggle reveal<CR>")
vim.api.nvim_create_autocmd("VimEnter", {
  command = "Neotree show reveal",
})
