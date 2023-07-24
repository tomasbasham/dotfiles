return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'puppet',
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

        -- See: https://github.com/puppetlabs/puppet-editor-services.
        puppet = {},
      },
    },
  },
}
