if vim.g.did_load_autocommands_plugin then
  return
end
vim.g.did_load_autocommands_plugin = true

local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal('noundofile')
  end,
})

-- Disable spell checking in terminal buffers
local nospell_group = api.nvim_create_augroup('nospell', { clear = true })
api.nvim_create_autocmd('TermOpen', {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

-- LSP
local keymap = vim.keymap

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  local buf, _ = vim.lsp.util.preview_location(result[1])
  if buf then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = vim.bo[cur_buf].filetype
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Attach plugins
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end

    vim.cmd.setlocal('signcolumn=yes')
    vim.bo[bufnr].bufhidden = 'hide'

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end
    keymap.set('n', '<M-j>D', vim.lsp.buf.declaration, desc('lsp [j]ump to [D]eclaration'))
    keymap.set('n', '<M-j>d', vim.lsp.buf.definition, desc('lsp [j]ump to [d]efinition'))
    keymap.set('n', '<M-j>t', vim.lsp.buf.type_definition, desc('lsp [j]ump to [t]ype definition'))
    keymap.set('n', '<M-j>i', vim.lsp.buf.implementation, desc('lsp [jump] to [i]mplementation'))
    keymap.set('n', '<M-p>d', peek_definition, desc('lsp [p]eek [d]efinition'))
    keymap.set('n', '<M-p>t', peek_type_definition, desc('lsp [p]eek [t]ype definition'))
    --    keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('lsp add [w]orksp[a]ce folder'))
    --    keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp [w]orkspace folder [r]emove'))
    --    keymap.set('n', '<space>wl', function()
    --      vim.print(vim.lsp.buf.list_workspace_folders())
    --    end, desc('[lsp] [w]orkspace folders [l]ist'))
    -- keymap.set('n', 'wq', vim.lsp.buf.workspace_symbol, desc('lsp [w]orkspace symbol [q]uery'))
    keymap.set('n', '<M-c>n', vim.lsp.buf.rename, desc('lsp [c]hange [n]ame'))
    keymap.set('n', '<M-q>d', vim.lsp.buf.document_symbol, desc('lsp [q]uickfix: [d]ocument symbols'))
    keymap.set('n', '<M-q>r', vim.lsp.buf.references, desc('lsp [q]uickfix: [r]eferences'))
    keymap.set('n', '<M-space>', vim.lsp.buf.hover, desc('[lsp] hover'))
    keymap.set('n', '<M-s>', vim.lsp.buf.signature_help, desc('[lsp] [s]ignature help'))
    keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, desc('[lsp] code action'))
    keymap.set('n', '<M-S-CR>', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source" },
          diagnostics = {},
        },
      })
    end, desc('[lsp] source action'))
    keymap.set('n', '<M-l>', vim.lsp.codelens.run, desc('[lsp] run code lens'))
    keymap.set('n', '<M-r>', vim.lsp.codelens.refresh, desc('[lsp] code lenses [r]efresh'))

    if client and client.server_capabilities.inlayHintProvider then
      keymap.set('n', '<M-h>', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      end, desc('[lsp] toggle inlay [h]ints'))
    end

    -- Auto-refresh code lenses
    if not client then
      return
    end
    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
        group = group,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = bufnr }
        end,
        buffer = bufnr,
      })
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end
  end,
})

-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})
api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})
