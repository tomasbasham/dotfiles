return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'starlark',
      })
    end,
  },

  -----------------
  --- lspconfig ---
  -----------------

  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      local lspconfig = require('lspconfig')
      local configs = require('lspconfig.configs')
      local util = require('util')

      if not configs.bzl then
        configs.bzl = {
          default_config = {
            cmd = { 'bzl', 'lsp', 'serve' },
            filetypes = { 'bzl' },
            root_dir = lspconfig.util.root_pattern('WORKSPACE.bazel', '.git'),
          },
        }
      end

      return util.tbl_merge(opts, {
        servers = {
          bzl = {
            -- This server is not particularly useful so it has been disabled.
            enabled = false,
          },
        },
      })
    end
  },
}
