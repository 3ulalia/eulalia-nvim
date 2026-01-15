if vim.fn.executable('ocamllsp') ~=1 then
  return
end

local root_files = {
  'dune-project',
  '.git',
  "*.opam",
  "esy.json",
  "package.json",
  "dune-workspace"
}

vim.g.no_ocaml_maps = 1

vim.lsp.start {
  name = 'ocamllsp',
  cmd = { 'ocamllsp' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
  settings = {
    config = {
      extendedHover = { enable = true },
      codelens = { enable = true },
      duneDiagnostics = { enable = false },
      inlayHints = { enable = true },
      syntaxDocumentation = { enable = true },
    },
  },
}


