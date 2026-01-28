vim.env.ESLINT_D_PPID = vim.fn.getpid() -- ??
require('lint').linters_by_ft = {
  nix = { "statix" },
  typescript = { "eslint_d" },
  javascript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  javascriptreact = { "eslint_d" },
}

require('lint').linters_by_ft["typescript.tsx"] = { "eslint_d" };
require('lint').linters_by_ft["javascript.jsx"] = { "eslint_d" };

local lint = function() require("lint").try_lint() end


vim.keymap.set({ 'n', 'x' }, '<M-l>', lint, { desc = "[lsp]: [l]int" })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", }, {
  pattern = "*",
  callback = lint
})
