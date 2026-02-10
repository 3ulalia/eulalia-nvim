vim.env.ESLINT_D_PPID = vim.fn.getpid() -- ??

local lint = require 'lint'

lint.linters.mathlib4 = {
  name = 'mathlib',
  cmd = 'scripts/lint-style.py',
  stdin = false,
  stream = 'stdout',
  ignore_exitcode = true,
  parser = require('lint.parser').from_pattern(
    '::(%l+) file=([^:]+),line=(%d+),code=ERR_(%w+)::[^ ]+ ERR_%w+: (.+)',
    { 'severity', 'file', 'lnum', 'code', 'message' }
  ),
}

lint.linters_by_ft = {
  nix = { "statix" },
  typescript = { "eslint_d" },
  javascript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  -- lean = { 'mathlib4' }, -- TODO
}

lint.linters_by_ft["typescript.tsx"] = { "eslint_d" };
lint.linters_by_ft["javascript.jsx"] = { "eslint_d" };

local lint_fn = function() require("lint").try_lint() end


vim.keymap.set({ 'n', 'x' }, '<M-l>', lint_fn, { desc = "[lsp]: [l]int" })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", }, {
  pattern = "*",
  callback = lint_fn
})
