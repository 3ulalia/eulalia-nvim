if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end


vim.keymap.set('n', '<leader>fw', builtin.find_files, { desc = '[f]ind files in c[w]d' })
vim.keymap.set('n', '<leader>ff', project_files, { desc = '[f]ind project or cwd [f]iles' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[f]ind with live [g]rep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[f]ind [b]uffer' })
vim.keymap.set('n', '<leader>fs', builtin.treesitter, { desc = '[f]ind tree[s]itter names' })
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = '[f]ind [i]mplementations' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = '[f]ind [d]efinitions' })
vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { desc = '[f]ind [t]ype definitions' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = '[f]ind [r]eferences' })
vim.keymap.set('n', '<leader>fci', builtin.lsp_incoming_calls, { desc = '[f]ind [c]alls ([i]ncoming)' })
vim.keymap.set('n', '<leader>fco', builtin.lsp_outgoing_calls, { desc = '[f]ind [c]alls ([o]utgoing)' })
vim.keymap.set(
  'n',
  '<leader>f<space>',
  grep_string_current_file_type,
  { desc = '[f]ind current string [space] in cwd with current filetype' }
)
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = 'grep current string [*]' })
vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = '[f]ind in [q]uickfix list' })
vim.keymap.set('n', '<leader>fh', builtin.command_history, { desc = '[f]ind in command [h]istory' })
vim.keymap.set('n', '<leader>fl', builtin.loclist, { desc = '[f]ind in [l]oclist' })
vim.keymap.set(
  'n',
  '<leader>f/',
  builtin.current_buffer_fuzzy_find,
  { desc = '[f]uzzy [/]find in current buffer' }
)

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    layout_config = layout_config,
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        -- ['<esc>'] = actions.close,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
      },
      n = {
        q = actions.close,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {

      }
    },
    undo = {

    },
    manix = {

    },
  },
}

telescope.load_extension('fzy_native')
telescope.load_extension("ui-select")
telescope.load_extension("undo")
-- telescope.load_extension("manix") not rn

vim.keymap.set('n', '<leader>fu', telescope.extensions.undo.undo, { desc = '[f]ind in [u]ndolist' })
