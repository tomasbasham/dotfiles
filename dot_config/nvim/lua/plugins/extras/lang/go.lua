return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      -- TODO: move this to lspconfig
      vim.filetype.add({ extension = { templ = 'templ' } })

      vim.list_extend(opts.ensure_installed, {
        'go',
        'gomod',
        'gosum',
        'gowork',
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

        -- See: https://pkg.go.dev/golang.org/x/tools/gopls
        gopls = {
          settings = {
            gopls = {
              analyses = {
                composites = true,
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
              },
              codelenses = {
                generate = true,
                run_govulncheck = true,
                tidy = true,
                upgrade_dependency = true,
              },
              directoryFilters = {
                '-bazel-bin',
                '-bazel-out',
                '-bazel-testlogs',
                '-bazel-monorepo',
              },
              expandWorkspaceToModule = true,
              gofumpt = false,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              staticcheck = true,
              vulncheck = 'Imports',
            },
          },
        },

        -- See: https://templ.guide/commands-and-tools/ide-support
        templ = {},
      },
    },
  },

  -----------
  --- dap ---
  -----------

  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      'leoluz/nvim-dap-go',
      opts = {
        -- Start dlv in headless mode. You can specify subcommands and flags after --, e.g.,
        --   dlv debug -l 127.0.0.1:38697 --headless ./main.go -- subcommand --myflag=xyz
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = 'go',
            name = 'Attach remote',
            mode = 'remote',
            request = 'attach',
          },
        },
      },
      keys = function()
        local options = function(desc)
          return { desc = 'Go: ' .. desc, noremap = true, nowait = true, silent = true }
        end

        return {
          { '<leader>gt', function() require('dap-go').debug_test() end,      options('Test') },
          { '<leader>gT', function() require('dap-go').debug_last_test() end, options('Last Test') },
        }
      end,
    },
  },

  ---------------
  --- neotest ---
  ---------------

  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-go',
    },
    opts = {
      adapters = {
        ['neotest-go'] = {
          -- Here we can set options for neotest-go, e.g.
          -- args = { "-tags=integration" }
        },
      },
    },
  },
}
