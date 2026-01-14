if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- Buffer list navigation
keymap.set('n', '<leader>b[', vim.cmd.bprevious, { silent = true, desc = 'previous [b]uffer [' })
keymap.set('n', '<leader>b]', vim.cmd.bnext, { silent = true, desc = 'next [b]uffer ]' })
keymap.set('n', '<leader>b{', vim.cmd.bfirst, { silent = true, desc = 'first [b]uffer {' })
keymap.set('n', '<leader>b}', vim.cmd.blast, { silent = true, desc = 'last [b]uffer }' })



-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set('n', 'qf', toggle_qf_list, { desc = 'toggle [q]uick[f]ix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', '<leader>q[', cleft, { silent = true, desc = 'cycle [q]uickfix [left' })
keymap.set('n', '<leader>q]', cright, { silent = true, desc = 'cycle [q]uickfix r]ight' })
keymap.set('n', '<leader>q{', vim.cmd.cfirst, { silent = true, desc = 'first [q]uickfix entry {' })
keymap.set('n', '<leader>q}', vim.cmd.clast, { silent = true, desc = 'last [q]uickfix entry }' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

keymap.set('n', '<leader>l[', lleft, { silent = true, desc = 'cycle [l]oclist [left' })
keymap.set('n', '<leader>l]', lright, { silent = true, desc = 'cycle [l]oclist r]ight' })
keymap.set('n', '<leader>l{', vim.cmd.lfirst, { silent = true, desc = 'first [l]oclist entry {' })
keymap.set('n', '<leader>l}', vim.cmd.llast, { silent = true, desc = 'last [l]oclist entry }' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<M-=>', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc [w]indow [w]idth' })
keymap.set('n', '<M-->', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec [w]indow [w]idth' })
keymap.set('n', '<M-S-=>', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc [w]indow [h]eight' })
keymap.set('n', '<M-S-->', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec [w]indow [h]eight' })

-- Close floating windows [Neovim 0.10 and above]
keymap.set('n', '<leader>wqf', function()
  vim.cmd('fclose!')
end, { silent = true, desc = '[w]indows: [q]uit/close [f]loating' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
--[[
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })
]]
-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<leader>tn', vim.cmd.tabnew, { desc = '[t]ab: [n]ew' })
keymap.set('n', '<leader>tq', vim.cmd.tabclose, { desc = '[t]ab: [q]uit/close' })

local severity = diagnostic.severity

keymap.set('n', '<leader>df', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = '[d]iagnostics [f]loating window' })
keymap.set('n', '<leader>dk', diagnostic.goto_prev, { noremap = true, silent = true, desc = '[k]previous [d]iagnostic' })
keymap.set('n', '<leader>dj', diagnostic.goto_next, { noremap = true, silent = true, desc = '[j]next [d]iagnostic' })
keymap.set('n', '<leader>dek', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = '[k]previous [d]iagnostic: [e]rror' })
keymap.set('n', '<leader>dej', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = '[j]next [d]iagnostic: [e]rror' })
keymap.set('n', '<leader>dwk', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = '[k]previous [d]iagnostic: [w]arning' })
keymap.set('n', '<leader>dwj', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = '[j]ext [d]iagnostic: [w]arning' })
keymap.set('n', '<leader>dhk', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = '[k]previous [d]iagnostic: [h]int' })
keymap.set('n', '<leader>dhj', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = '[j]next [d]iagnostic: [h]int ' })

local function buf_toggle_diagnostics()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<leader>dt', buf_toggle_diagnostics, { desc = "[d]iagnostics [t]oggle" })

local function toggle_spell_check()
  -- lua_ls is stupid sometimes, and that's okay
  ---@diagnostic disable-next-line: param-type-mismatch
  ---@diagnostic disable-next-line: undefined-field 
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move [u]p half-page and center' })
keymap.set('n', '<C-D>', '<C-f>zz', { desc = 'move [D]OWN full-page and center' })
keymap.set('n', '<C-U>', '<C-b>zz', { desc = 'move [U]P full-page and center' })

--- Disabled keymaps [enable at your own risk]

-- Automatic management of search highlight
-- XXX: This is not so nice if you use j/k for navigation
-- (you should be using <C-d>/<C-u> and relative line numbers instead ;)
--
-- local auto_hlsearch_namespace = vim.api.nvim_create_namespace('auto_hlsearch')
-- vim.on_key(function(char)
--   if vim.fn.mode() == 'n' then
--     vim.opt.hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
--   end
-- end, auto_hlsearch_namespace)
