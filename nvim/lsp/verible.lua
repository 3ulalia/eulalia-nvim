local root_files = {
  '.git',
}

return {
  name = 'verible',
  cmd = { 'verible-verilog-ls', '--rules', 'parameter-name-style=localparamstyle:ALL_CAPS,-always-comb,-explicit-parameter-storage-type,-unpacked-dimensions-range-ordering' },
  root_markers = root_files,
  --  capabilities = require('user.lsp').make_client_capabilities(),
  filetypes = { 'systemverilog', 'verilog' },
  settings = {
  },
}
