if vim.fn.executable('vtsls') ~= 1 then
  return
end

local root_files = {
  '.git',
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
  "package-lock.json",
  "yarn.lock",
  "pnpm-lock.yaml",
  "bun.lockb",
  "bun.lock"
}

vim.lsp.start {
  name = 'vtsls',
  cmd = { "vtsls", "--stdio" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = vim.tbl_deep_extend('force', require('user.lsp').make_client_capabilities(), require('lsp-file-operations').default_capabilities()),
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    hostInfo = "neovim"
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
    },
    vtsls = {
      experimental = {
        maxInlayHintLength = 40,
        enableProjectDiagnostics = true,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      enableMoveToFileCodeAction = true,
    },
  }
}

vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
  local locations = command.arguments[3]
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if locations and #locations > 0 then
    local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
    vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
    vim.api.nvim_command("lopen")
  end
end

vim.keymap.set('n', '<leader>trf', require('vtsls').commands.rename_file, { desc = '[t]ypescript: [r]ename [f]ile' } )
--[[

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
-- ]]

-- require('tsc').setup()
