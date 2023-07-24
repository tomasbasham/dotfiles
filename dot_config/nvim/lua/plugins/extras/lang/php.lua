return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'php',
      })
    end,
  },

  -----------------
  --- lspconfig ---
  -----------------

  {
    'nvim-lspconfig',
    optional = true,
    opts = function(_, opts)
      local util = require('util')

      -- See: https://github.com/bmewburn/intelephense-docs/blob/master/installation.md#configuration-options
      -- Add intelephense settings here.
      local settings = {}

      local phpVersion = os.getenv('PHP_VERSION')
      if phpVersion then
        settings = util.tbl_merge(settings, {
          environment = {
            phpVersion = phpVersion,
          },
        })
      end

      return util.tbl_merge(opts, {
        servers = {
          intelephense = {
            init_options = {
              -- no problem if the file doesn't exist yet, it will silently keep
              -- using the free version.
              licenceKey = table.concat({
                vim.env.HOME,
                '.config',
                'intelephense',
                'licence.key',
              }, '/'),
            },
            settings = {
              intelephense = settings,
            },
          },
        },
      })
    end,
  },
}
