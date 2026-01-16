require('conform').setup({
  formatters_by_ft = {
    ocaml = { "ocamlformat" },
  },

  formatters = {
    ocamlformat = {
      prepend_args = {
          "--if-then-else",
          "vertical",
          "--break-cases",
          "fit-or-vertical",
          "--type-decl",
          "sparse",
      },
    },
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

})

vim.keymap.set({'n', 'x'}, '<M-f>', function()
  require("conform").format()
  require("lint").try_lint()
  --vim.lsp.buf.format { async = true, bufnr = vim.api.nvim_get_current_buf() }
end, {desc = '[lsp] [f]ormat buffer'})


