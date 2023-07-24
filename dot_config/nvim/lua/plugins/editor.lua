return {

  ---------------------
  --- File Explorer ---
  ---------------------

  {
    'nvim-tree/nvim-tree.lua',
    enabled = true,
    opts = function()
      local api = require('nvim-tree.api')

      -- used to create key bindings on the nvim-tree buffer.
      local function on_attach(bufnr)
        local function options(desc)
          return { buffer = bufnr, desc = 'nvim-tree: ' .. desc, noremap = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', 'C', api.tree.change_root_to_node, options('Change Directory'))

        -- navigation
        vim.keymap.set('n', 'O', api.node.open.replace_tree_buffer, options('Open: In Place'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, options('Open: Vertical Split'))
        vim.keymap.set('n', '<C-h>', api.node.open.horizontal, options('Open: Horizontal Split'))
        vim.keymap.set('n', 'x', api.node.navigate.parent_close, options('Close Directory'))
        vim.keymap.set('n', '?', api.tree.toggle_help, options('Help'))
      end

      return {
        disable_netrw = true,
        hijack_cursor = true,
        sort_by = 'case_sensitive',
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            error = '⏵',
            warning = '▲',
            info = '■',
            hint = '●',
          },
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        git = {
          enable = true,
        },
        on_attach = on_attach,
        renderer = {
          group_empty = true,
          highlight_git = false,
          icons = {
            git_placement = 'signcolumn',
            show = {
              git = true,
              file = false,
              folder = false,
              folder_arrow = true,
            },
            glyphs = {
              bookmark = 'B',
              symlink = '',
              folder = {
                arrow_closed = '⏵',
                arrow_open = '⏷',
              },
              git = {
                unstaged = '✗',
                staged = '✚',
                unmerged = '⌥',
                renamed = '➜',
                untracked = '★',
                deleted = '⊖',
                ignored = '◌',
              },
            },
          },
        },
        update_focused_file = {
          enable = false,
        },
        view = {
          width = 30,
          side = 'left',
          signcolumn = 'yes',
        },
      }
    end,
    config = function(_, opts)
      local tree = require('nvim-tree')
      tree.setup(opts)

      -- open/close the nvim-tree buffer, replacing the current buffer when
      -- open.
      local function toggle_replace()
        local view = require('nvim-tree.view')
        if view.is_visible() then
          view.close()
        else
          tree.open_replacing_current_buffer()
        end
      end

      local api = require('nvim-tree.api')
      local options = { noremap = true, nowait = true }

      -- open nvim-tree, replacing the current buffer, like vim-vinegar.
      -- See: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
      vim.keymap.set('n', '-', toggle_replace, options)

      local util = require('util')
      local find_file_opts = { open = true, focus = true, update_root = true }

      -- open nvim-tree as a drawer, like NerdTree.
      vim.keymap.set('n', '<Leader>t', api.tree.toggle, options)
      vim.keymap.set('n', '<C-f>', util.wrap(api.tree.find_file, find_file_opts), options)
    end,
  },

  -----------
  --- Git ---
  -----------

  {
    'f-person/git-blame.nvim',
    cmd = {
      'GitBlameCopyCommitURL',
      'GitBlameCopyFileURL',
      'GitBlameCopySHA',
      'GitBlameDisable',
      'GitBlameEnable',
      'GitBlame0penCommitURL',
      'GitBlame0penFileURL',
      'GitBlameToggle',
    },
    enabled = true,
    keys = {
      '<M-b>',
    },
    config = function()
      local options = { noremap = true, nowait = true, silent = true }
      vim.keymap.set('n', '<M-b>', ':GitBlameToggle<CR>', options)
    end,
  },

  ------------------------
  --- Multiple Cursors ---
  ------------------------

  {
    'mg979/vim-visual-multi',
    enabled = true,
    keys = {
      { '<C-n>', mode = { 'n', 'v' } },
    },
    init = function()
      vim.g.VM_default_mappings = false
    end,
  },

  -------------------------------
  --- Search and Fuzzy Finder ---
  -------------------------------

  {
    'ibhagwan/fzf-lua',
    cmd = {
      'FzfLua',
    },
    enabled = true,
    keys = {
      '<C-p>',
      '<S-l>',
      '<S-b>',
      '<S-h>',
    },
    opts = {
      winopts = {
        preview = {
          hidden = 'hidden',
        },
        row = 1.00,   -- keep it to the bottom
        col = 0.00,   -- keep it to the left
        width = 1.00, -- use full width
        height = 0.25,
      },
    },
    config = function(_, opts)
      local fzf = require('fzf-lua')
      local options = { noremap = true, nowait = true, silent = true }

      vim.keymap.set('n', '<C-p>', fzf.files, options)
      vim.keymap.set('n', '<S-l>', fzf.lines, options)
      vim.keymap.set('n', '<S-b>', fzf.buffers, options)
      vim.keymap.set('n', '<S-h>', fzf.oldfiles, options)

      fzf.setup(opts)
    end,
  },

  {
    'mhinz/vim-grepper',
    enabled = true,
    keys = {
      { '<Leader>a', desc = 'Open grepper prompt' },
      { 'gs',        desc = 'Grepper operator',   mode = { 'v' } }
    },
    config = function()
      vim.g.grepper = {
        tools = { 'rg', 'ag', 'pt', 'ack', 'git', 'grep' },
        highlight = 1,
        stop = 3000,
        open = 0,
        switch = 1,
        prompt = 0,
      }

      -- open the quickfix list automatically when a search is run.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'Grepper',
        command = 'copen',
      })

      -- build a command that supports both current word (when no args are
      -- given), and path completion (like :Ack), because the Grepper prompt
      -- does not support completion.
      --
      -- what is suggested in the vim-grepper docs does not address this need,
      -- because setting g:grepper.prompt to 0 will allow path completion after
      -- the search pattern, but it will not search for the current word with no
      -- input.
      local function search_func(opts)
        if opts.args == '' then
          vim.api.nvim_exec('Grepper -noprompt -cword', false)
        else
          vim.api.nvim_exec('Grepper -noprompt -query ' .. opts.args, false)
        end
      end

      local function options(desc)
        return { desc = 'Grepper: ' .. desc, noremap = true, nowait = true }
      end

      -- create a command, :Grep, that will search for the current word if no
      -- args are given, or search for the given args.
      vim.api.nvim_create_user_command('Grep', search_func, { nargs = '*', complete = 'file' })

      -- create a keymap to open the Grepper prompt.
      vim.keymap.set('n', '<Leader>a', ':Grep ', options('Open Search Prompt'))

      ----------------
      --- Operator ---
      ----------------

      -- This defines an operator "gs" that takes any selection and starts
      -- searching for the selected query right away. The query is quoted
      -- automatically.
      vim.keymap.set('v', 'gs', '<plug>(GrepperOperator)', options('Operator'))
    end,
  },

  ---------------------
  --- Text Varients ---
  ---------------------

  {
    'tpope/vim-abolish',
    cmd = {
      'Abolish',
      'Subvert',
    },
    enabled = true,
  },

  ----------------
  --- Bindings ---
  ----------------

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
}
