require("typst-preview").setup({
  dependencies_bin = {
    ['tinymist'] = "tinymist",
    ['websocat'] = "websocat",
  },
})

vim.keymap.set('n', '<leader>tv', '<CMD>TypstPreviewToggle<CR>', { desc = '[t]ypst: toggle pre[v]iew' })
vim.keymap.set('n', '<leader>tc', '<CMD>TypstPreviewFollowCursorToggle<CR>', { desc = '[t]ypst: toggle [c]ursor following' })
vim.keymap.set('n', '<leader>ts', '<CMD>TypstPreviewSyncCursor<CR>', { desc = '[t]ypst: [s]ync cursor position' })

require("img-clip").setup({
  default = {
    file_name = "$FILE_NAME",
  }
})

vim.keymap.set('n', '<leader>tp', '<CMD>PasteImage', { desc = '[t]ypst: [p]aste image from clipboard' })
