return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'markdown',
        'markdown_inline',
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

        -- See: https://github.com/artempyanykh/marksman
        marksman = {},
      },
    },
  },
}
