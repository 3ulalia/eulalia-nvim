local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'ty.toml',
  '.git',
}

return {
  name = 'ty',
  cmd = { 'ty', 'server' },
  root_markers = root_files,
--  capabilities = require('user.lsp').make_client_capabilities(),
  settings = {
    ty = {
    }
  },
}
