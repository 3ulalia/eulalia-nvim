-- Exit if the language server isn't available
if vim.fn.executable('nil') ~= 1 then
  return
end

local root_files = {
  'flake.nix',
  'default.nix',
  'shell.nix',
  '.git',
}

vim.lsp.start {
  name = 'nil_ls',
  cmd = { 'nil' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  settings = {
    nil_ls = {
      formatting = {
        command = {"alejandra"},
      },
-- old nixd options to set flake location for nixos and home-manager option completion
--      nixos = {
--        expr = "(builtins.getFlake (builtins.toString ~/flake)).nixosConfigurations.${builtins.replaceStrings ['\n'] [''] (builtins.readFile /etc/hostname)}.options",
--      },
--      home_manager = {
--        expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${builtins.replaceStrings ['\n'] [''] (builtins.readFile /etc/hostname)}.options.home-manager.users.type.getSubOptions []",
--      },
    },
  },
}

--[[
vim.keymap.set('n', '<leader>nd', function()
  require('telescope-manix').search({ cword = true })
end, { desc = '[n]ix: search [d]ocs for word' })
vim.keymap.set('n', '<leader>nD', require('telescope-manix').search, { desc = '[n]ix: search [D]ocs' })
vim.keymap.set('n', '<leader>fu', telescope.extensions.undo.undo, { desc = '[f]ind in [u]ndolist' })
]]--
