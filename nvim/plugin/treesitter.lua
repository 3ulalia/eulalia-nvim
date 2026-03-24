if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

local configs = require('nvim-treesitter')
vim.g.skip_ts_context_comment_string_module = true

---@diagnostic disable-next-line: missing-fields
configs.setup {
  --[[ old version of treesitter's config (master vs main)
  -- ensure_installed = 'all',
  -- auto_install = false, -- Do not automatically install missing parsers when entering buffer
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobject, similar to targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@call.outer',
        ['iC'] = '@call.inner',
        ['a#'] = '@comment.outer',
        ['i#'] = '@comment.outer',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.outer',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['aP'] = '@parameter.outer',
        ['iP'] = '@parameter.inner',
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']P'] = '@parameter.outer',
      },
      goto_next_end = {
        [']m'] = '@function.outer',
        [']P'] = '@parameter.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[P'] = '@parameter.outer',
      },
      goto_previous_end = {
        ['[m'] = '@function.outer',
        ['[P'] = '@parameter.outer',
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['df'] = '@function.outer',
        ['dF'] = '@class.outer',
      },
    },
  }, ]]
}
-- nvim-treesitter-textobjects

-- select
vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'as', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
end, {})

-- swap
vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end, {})
vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end, {})

-- move
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end, { desc = '[m] next function (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end, { desc = '[M] next function (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
end, { desc = '[p] next parameter (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
end, { desc = '[P] next parameter (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end, { desc = '[m] previous function (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end, { desc = '[M] previous function (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
end, { desc = 'previous [p]arameter (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
end, { desc = 'previous [P]arameter (end)' })


require('treesitter-context').setup {
  max_lines = 3,
}

require('ts_context_commentstring').setup()

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
