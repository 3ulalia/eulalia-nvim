local ts_fmt = { "prettierd", "eslint_d" }

require('conform').setup({
  formatters_by_ft = {
    ocaml = { "ocamlformat" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    typescript = ts_fmt,
    javascript = ts_fmt,
    typescriptreact = ts_fmt,
    javascriptreact = ts_fmt,
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

local format = function()
  require("conform").format()
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = format
})


vim.keymap.set({'n', 'x'}, '<M-f>', format, {desc = '[lsp] [f]ormat buffer'})

