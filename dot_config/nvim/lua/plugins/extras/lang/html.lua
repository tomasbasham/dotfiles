return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'html',
        'css',
        'scss',
      })
    end,
  },

  -----------------
  --- lspconfig ---
  -----------------

  {
    'nvim-lspconfig',
    opts = {
      servers = {

        -- See: https://github.com/hrsh7th/vscode-langservers-extracted
        cssls = {},

        -- See: https://github.com/hrsh7th/vscode-langservers-extracted
        html = {
          init_options = {
            -- This does not play nice with templ and actually makes some pretty
            -- ugly formatting decisions.
            provideFormatter = false,
          },
        },

        -- See:
        htmx = {},
      },
    },
  },
}
