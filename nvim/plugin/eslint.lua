if vim.fn.executable('eslint') ~= 1 then
  return
end

-- vim.lsp.set_log_level('debug')
require('nvim-eslint').setup({})

