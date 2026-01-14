if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

local navic = require('nvim-navic')
navic.setup {
  lsp = {
    auto_attach = true,
  },
  click = true,
  highlight = false,  -- TODO
}

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

require('lualine').setup {
  globalstatus = true,
  sections = {
    lualine_b = {'branch', 'diff'},
    lualine_c = {
      { 'filename', path = 1, file_status = true, newfile_status = true, },
      { 'diagnostics',
        sources = {
          'nvim_lsp',
          'nvim_diagnostic',
        },
      },
    },
    lualine_x = {
      'lsp_status',
      'filetype',
    },
    lualine_y = {
      'location',
      'progress',
    },
    lualine_z = {
      -- (see above)
      { extra_mode_status },
    },
  },
  options = {
    theme = 'auto',
  },
  -- Example top tabline configuration (this may clash with other plugins)
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 0,
      },
    },
    lualine_b = {
      {
        'windows',
        mode = 2,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'datetime',
        style = 'default',
      },
    },
  },
  winbar = {
    lualine_a = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_b = {
      -- nvim-navic
      { navic.get_location, cond = navic.is_available },
    },
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
}
