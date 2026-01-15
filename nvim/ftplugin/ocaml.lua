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

require("ocaml").setup() --[[
  keymaps = {
    jump_next_hole = '<leader>ohj',
    jump_prev_hole = '<leader>ohk',
    construct = '<leader>oc',
    jump = '<leader>oj',
    phrase_prev = '<leader>opk',
    phrase_next = '<leader>opj',
    type_enclosing = '<leader>ot',
    type_enclosing_grow = 'k',
    type_enclosing_shrink = 'j',
    type_enclosing_increase = 'l',
    type_enclosing_decrease = 'h',
  }
})
]]
