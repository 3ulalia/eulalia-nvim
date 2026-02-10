if vim.fn.executable('lean') ~= 1 then
  return
end

local lean = require 'lean'

lean.setup {
  infoview = {
    autoopen = true,
  }
}

vim.api.nvim_create_autocmd('VimResized', { callback = require('lean.infoview').reposition })

local group = vim.api.nvim_create_augroup('LeanAutoOpenClose', {})

vim.api.nvim_create_autocmd('QuitPre', {
  group = group,
  pattern = { '*.lean' },
  callback = function()
    local infoview = require('lean.infoview').get_current_infoview()
    if infoview then
      local tab_wins = vim.api.nvim_tabpage_list_wins(0)
      local lean_wins = vim.tbl_filter(function(w)
        local buf = vim.api.nvim_win_get_buf(w)
        local buf_ft = vim.api.nvim_buf_get_option_value(buf, 'filetype')
        return buf_ft == 'lean'
      end, tab_wins)
      if #lean_wins <= 1 then
        infoview:close()
      end
    end
  end
})

vim.lsp.config('leanls', {
  init_options = {
    editDelay = 300,
    hasWidgets = true,
  },
})
vim.lsp.enable('leanls')

local key = vim.keymap

key.set('n', '<leader>lg', '<CMD>LeanGoal<CR>', { desc = '[l]ean: [g]oal (any)' })
key.set('n', '<leader>lt', '<CMD>LeanTermGoal<CR>', { desc = '[l]ean: [t]erm goal' })
key.set('n', '<leader>lp', '<CMD>LeanPlainGoal<CR>', { desc = '[l]ean: [p]lain goal' })
key.set('n', '<leader>lP', '<CMD>LeanPlainTermGoal<CR>', { desc = '[l]ean: [P]lain term goal' })
key.set('n', '<leader>lf', '<CMD>LeanSorryFill<CR>', { desc = '[l]ean: [f]ill sorry' })

key.set('n', '<leader>lR', '<CMD>LeanGoal<CR>', { desc = '[l]ean: [R]estart file' })
key.set('n', '<leader>lr', '<CMD>LeanGoal<CR>', { desc = '[l]ean: [r]efresh file dependencies' })

key.set('n', '<leader>ld', '<CMD>LeanGoal<CR>', { desc = '[l]ean: [d]iagnostics (line)' })
key.set('n', '<leader>lD', '<CMD>LeanGoal<CR>', { desc = '[l]ean: [D]iagnostics (plain)' })

key.set('n', '<leader>la', '<CMD>LeanAbbreviationsReverseLookup<CR>', { desc = '[l]ean: [a]bbreviation reverse lookup' })

key.set('n', '<leader>lii', '<CMD>LeanInfoviewToggle<CR>', { desc = '[l]ean: toggle [i][i]nfoview' })

key.set('n', '<leader>lia', '<CMD>LeanInfoviewAddPin<CR>', { desc = '[l]ean: [i]nfoview: [a]dd pin' })
key.set('n', '<leader>lic', '<CMD>LeanInfoviewClearPins<CR>', { desc = '[l]ean: [i]nfoview: [c]lear pins' })
key.set('n', '<leader>liA', '<CMD>LeanInfoviewSetDiffPin<CR>', { desc = '[l]ean: [i]nfoview: [A]dd (set) diff pin' })
key.set('n', '<leader>liC', '<CMD>LeanInfoviewClearDiffPin<CR>', { desc = '[l]ean: [i]nfoview: [C]lear diff pin' })
key.set('n', '<leader>liP', '<CMD>LeanInfoviewPinTogglePause<CR>', { desc = '[l]ean: [i]nfoview: [P]in toggle pause' })
key.set('n', '<leader>lit', '<CMD>LeanInfoviewToggleAutoDiffPin<CR>',
  { desc = '[l]ean: [i]nfoview: [t]oggle auto diff pin' })
key.set('n', '<leader>liT', '<CMD>LeanInfoviewToggleNoClearAutoDiffPin<CR>',
  { desc = '[l]ean: [i]nfoview: [T]oggle no clear auto diff pin' })

key.set('n', '<leader>lig', '<CMD>LeanGotoInfoview<CR>', { desc = '[l]ean: [i]nfoview: [g]oto' })
key.set('n', '<leader>lio', '<CMD>LeanInfoviewViewOptions<CR>', { desc = '[l]ean: [i]nfoview: view [o]ptions' })
key.set('n', '<leader>liw', '<CMD>LeanInfoviewEnableWidgets<CR>', { desc = '[l]ean: [i]nfoview: enable [w]idgets' })
key.set('n', '<leader>liW', '<CMD>LeanInfoviewDisableWidgets<CR>', { desc = '[l]ean: [i]nfoview: disable [W]idgets' })
