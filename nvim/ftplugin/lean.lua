if vim.fn.executable('lean') ~= 1 then
  return
end

require('lean').setup {
  mappings = true,

  lsp = {
    init_options = {
      editDelay = 10,
    },
  },
}
