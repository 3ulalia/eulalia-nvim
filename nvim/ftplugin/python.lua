if vim.fn.executable("ty") ~= 1 then
  return
end

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'ty.toml',
  '.git',
}

vim.lsp.config {
  name = 'ty',
  cmd = { 'ty', 'server' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
  settings = {
    ty = {
    }
  },
}
