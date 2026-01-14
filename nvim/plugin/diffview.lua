if vim.g.did_load_diffview_plugin then
  return
end
vim.g.did_load_diffview_plugin = true

vim.keymap.set('n', '<leader>gb', function()
  vim.cmd.DiffviewFileHistory(vim.api.nvim_buf_get_name(0))
end, { desc = '[g]it diffview history (current [b]uffer)' })
vim.keymap.set('n', '<leader>gh', vim.cmd.DiffviewFileHistory, { desc = '[g]it diffview [h]istory (cwd)' })
vim.keymap.set('n', '<leader>gv', vim.cmd.DiffviewOpen, { desc = '[g]it diff[v]iew open' })
vim.keymap.set('n', '<leader>gt', vim.cmd.DiffviewToggleFiles, { desc = '[g]it diffview files [t]oggle' })


