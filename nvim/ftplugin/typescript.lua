if vim.fn.executable('ts_ls') ~=1 then
  return
end

local root_files = {
  '.git',
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
}

vim.lsp.start {
  name = 'ts_ls',
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
}

require("ts-error-translator").setup({
  -- Auto-attach to LSP servers for TypeScript diagnostics (default: true)
  auto_attach = true,

  -- LSP server names to translate diagnostics for (default shown below)
  servers = {
    "astro",
    "svelte",
    "ts_ls",
    "tsserver",           -- deprecated, use ts_ls
    "typescript-tools",
    "volar",
    "vtsls",
  },
})
