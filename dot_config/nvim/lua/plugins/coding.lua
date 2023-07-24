return {

  ----------------
  --- Snippets ---
  ----------------

  {
    'L3MON4D3/LuaSnip',
    build = (not jit.os:find('Windows'))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    keys = {
      {
        '<tab>',
        function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { '<tab>',   function() require('luasnip').jump(1) end,  mode = 's' },
      { '<s-tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
    },
  },

  -------------------
  --- Completions ---
  -------------------

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    enabled = true,
    event = {
      'CmdlineEnter',
      'InsertEnter',
    },
    opts = function()
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()

      -- create a reusable window config.
      local window_config = cmp.config.window.bordered({
        border = 'rounded',
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      })

      return {
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>']  = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>']  = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>']  = cmp.mapping.scroll_docs(-4),
          ['<C-f>']  = cmp.mapping.scroll_docs(4),
          -- Default confirmation mapping. Specify `cmp.config.disable` if you
          -- want to remove the default `<C-y>` mapping.
          ['<C-y>']  = cmp.config.disable,
          ['<C-e>']  = cmp.mapping.abort(),
          ['<CR>']   = cmp.mapping.confirm({ select = false }),
          ['<Tab>']  = cmp.mapping.confirm({ select = false }),
          ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.SelectBehavior.Replace, select = true }),
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        window = {
          documentation = window_config,
          completion = window_config,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require('cmp')
      cmp.setup(opts)

      --- Filetype Completions ---

      -- gitcommit filetype should prefer git commit suggestions.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'buffer' },
        }),
      })

      --- Commandline Completion ---

      local mapping = cmp.mapping.preset.cmdline({
        ['<Down>'] = { c = cmp.mapping.select_next_item() },
        ['<Up>']   = { c = cmp.mapping.select_prev_item() },
        ['<C-n>']  = { c = cmp.mapping.select_next_item() },
        ['<C-p>']  = { c = cmp.mapping.select_prev_item() },
        -- Default confirmation mapping. Specify `cmp.config.disable` if you
        -- want to remove the default `<C-y>` mapping.
        ['<C-y>']  = { c = cmp.config.disable },
        ['<C-e>']  = { c = cmp.mapping.abort() },
        ['<CR>']   = { c = cmp.mapping.confirm({ select = false }) },
      })

      -- commands starting with '/' should prefer buffer suggestions.
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = mapping,
        sources = {
          { name = 'buffer' },
        },
      })

      -- commands starting with ':' should prefer path suggestions.
      cmp.setup.cmdline(':', {
        mapping = mapping,
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        }),
      })
    end,
  },

  ----------------
  --- Comments ---
  ----------------

  {
    'numToStr/Comment.nvim',
    -- TODO: lazy load for `[count]gcc` and `[count]gbc`
    keys = {
      { '<C-_>', mode = { 'n', 'x' } },
      { 'gc',    mode = { 'x' } },
      { 'gb',    mode = { 'x' } },
      'gcc',
    },
    opts = function()
      return {
        ignore = '^%s*$', -- ignore blank lines.
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
    config = function(_, opts)
      require('Comment').setup(opts)

      local comment_api = require('Comment.api')
      local map = vim.keymap.set
      local options = { noremap = true, nowait = true, silent = true }

      -- toggle current line and visual (linewise) using `C-/`.
      map('n', '<C-_>', comment_api.toggle.linewise.current, options)

      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

      -- toggle selection (linewise).
      map('x', '<C-_>', function()
        vim.api.nvim_feedkeys(esc, 'nx', false)
        comment_api.toggle.linewise(vim.fn.visualmode())
      end, options)
    end
  },

  ----------------
  --- Surround ---
  ----------------

  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = { 'x' } }
    },
    opts = {},
  },
}
