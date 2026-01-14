if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

vim.schedule(function()
  require('gitsigns').setup {
    current_line_blame = false,
    current_line_blame_opts = {
      ignore_whitespace = true,
    },

    status_formatter = function(status)
      return {
        added = status.added,
        modified = status.changed,
        removed = status.removed,
      }
    end,

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']g', function()
        if vim.wo.diff then
          return ']g'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[g]it next hunk' })

      map('n', '[g', function()
        if vim.wo.diff then
          return '[g'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[g]it previous hunk' })

      -- Actions
      map({ 'n', 'v' }, '<leader>gs', function()
        vim.cmd.Gitsigns('stage_hunk')
      end, { desc = '[g]it [s]tage hunk' })
      map({ 'n', 'v' }, '<leader>gr', function()
        vim.cmd.Gitsigns('reset_hunk')
      end, { desc = '[g]it [r]eset hunk' })
      map('n', '<leader>gS', gs.stage_buffer, { desc = '[g]it [S]tage buffer' })
      map('n', '<leader>gu', gs.undo_stage_hunk, { desc = '[g]it [u]ndo stage hunk' })
      map('n', '<leader>gR', gs.reset_buffer, { desc = '[g]it [R]eset buffer' })
      map('n', '<leader>gp', gs.preview_hunk, { desc = '[g]it hunk [p]review' })
      map('n', '<leader>gB', function()
        gs.blame_line { full = true }
      end, { desc = '[g]it [B]lame line (full)' })
      map('n', '<leader>gl', gs.toggle_current_line_blame, { desc = '[g]it toggle current [l]ine blame' })
      map('n', '<leader>gd', gs.diffthis, { desc = '[g]it [d]iff this' })
      map('n', '<leader>gD', function()
        gs.diffthis('~')
      end, { desc = '[g]it [D]iff ~' })
      map('n', '<leader>gt', gs.toggle_deleted, { desc = '[g]it [t]oggle deleted' })
      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'git stage buffer' })
    end,
  }
end)
