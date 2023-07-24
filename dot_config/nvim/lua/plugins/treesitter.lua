return {
  {
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
          enable_autocmd = false,
        },
      },
    },
    build = ':TSUpdate',
    event = {
      'BufReadPost',
      'BufNewFile',
    },
    cmd = {
      'TSUpdateSync',
    },
    keys = {
      { '<c-space>', desc = 'Increase selection' },
      { '<bs>',      desc = 'Decrement selection', mode = 'x' },
    },
    opts = {
      -- Automatically install missing parsers when entering buffer.
      -- Set to false if you don't have `tree-sitter` CLI installed locally.
      auto_install = true,

      -- A list of parser names, or 'all'.
      ensure_installed = {
        'arduino',
        'bash',
        'bibtex',
        'c',
        'cmake',
        'comment',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'jsonc',
        'latex',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'php',
        'proto',
        'python',
        'query', -- Tree Sitter's own syntax
        'regex',
        'rego',
        'rst',
        'ruby',
        'rust',
        'scss',
        'sql',
        'starlark',
        'toml',
        'tsx',
        'typescript',
        'vimdoc',
        'yaml',
      },

      -- List of parsers to ignore installing (for "all").
      -- ignore_install = { "javascript" },

      highlight = {
        -- TODO: Setting this to true will run `:set syntax` and tree-sitter at
        -- the same time.
        --
        -- Set this to `true` if you depend on 'syntax' being enabled (like for
        -- indentation). Using this option may slow down your editor, and you
        -- may see some duplicate highlights.
        --
        -- Instead of true it can also be a list of languages.
        additional_vim_regex_highlighting = false,

        -- `false` will disable the whole extension.
        enable = true,

        -- List of language that will be disabled.
        disable = {},

        -- Or use a function for more flexibility, e.g. to disable slow
        -- treesitter highlight for large files.
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,
      },

      -- Incremental selection based on the named nodes from the grammar.
      incremental_selection = {
        -- `false` will disable the whole extension.
        enable = true,

        -- Keymaps of the captured groups. Setting any property to `false` will
        -- disable the mapping.
        keymaps = {
          init_selection = '<C-space>',   -- maps in normal mode to init the node/scope selection
          node_incremental = '<C-space>', -- increment to the upper named parent
          scope_incremental = false,      -- increment to the upper scope (as defined in locals.scm)
          node_decremental = '<bs>'       -- decrement to the previous node
        },
      },

      -- Indentation based on treesitter for the `=` operator.
      -- NOTE: This is an experimental feature.
      indent = {
        -- `false` will disable the whole extension.
        enable = false,

        -- List of language that will be disabled.
        disable = {
          'markdown',
        },
      },

      -- Install parsers synchronously (only applied to `ensure_installed`).
      sync_install = false,

      -- The textobjects module requires the
      -- 'nvim-treesitter/nvim-treesitter-textobjects' plugin.
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          -- lookahead = true,

          -- See also: https://github.com/ray-x/go.nvim#text-object

          keymaps = {
            -- ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
            -- capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer', -- or ['aC']
            ['ic'] = '@class.inner', -- or ['iC']
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
            ['ae'] = '@block.outer',
            ['ie'] = '@block.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['is'] = '@statement.inner',
            ['as'] = '@statement.outer',
            ['ad'] = '@comment.outer',
            ['am'] = '@call.outer',
            ['im'] = '@call.inner',
          },
        },
      },

      ------------------------------
      --- Treesitter textobjects ---
      ------------------------------

      lsp_interop = {
        enable = true,
      },

      move = {
        enable = true,
        set_jumps = false, -- whether to set jumps in the jumplist
      },

      swap = {
        enable = false,
      },
    },
  },
}
