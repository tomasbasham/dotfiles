return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'hcl',
        'terraform',
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

        -- See: https://github.com/hashicorp/terraform-ls
        terraformls = {},

        -- See: https://github.com/terraform-linters/tflint
        tflint = {},
      },
    },
  },
}
