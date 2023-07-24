-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/plugins/lsp/init.lua
-- ============================================================================
-- Plugin configuration for LSP-related plugins. This module will setup the
-- LSP servers and the LSP client capabilities.

return {

  -----------------
  --- lspconfig ---
  -----------------

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/lsp_signature.nvim',

      -- Required to ensure LSP servers are available on the $PATH. lspconfig
      -- will auto-start servers if they are available on the $PATH.
      'mason.nvim',
    },
    ---@class PluginLspOpts
    opts = {
      actions = {
        enabled = true,
        timeout_ms = 1000,
      },
      capabilities = {},
      diagnostics = {
        settings = {
          float = {
            border = 'rounded',
            focusable = true,
            header = '',
            prefix = '',
            source = 'always',
            style = 'minimal',
          },
          severity_sort = true,
          underline = false,
          update_in_insert = false,
          virtual_text = {
            prefix = '■',
            -- Only issues with the specified severity or higher will be printed
            -- at the end of the lines, the minor ones will only get a column
            -- sign.
            severity = { min = vim.diagnostic.severity.ERROR },
            source = 'if_many',
          },
        },
        signs = {
          DiagnosticSignError = '►',
          DiagnosticSignWarn = '▲',
          DiagnosticSignInfo = '■',
          DiagnosticSignHint = '●',
        },
      },
      formatting = {
        enabled = true,
      },
      servers = {

        -- See: https://github.com/arduino/arduino-language-server
        arduino_language_server = {},

        -- See: https://github.com/bash-lsp/bash-language-server
        bashls = {
          filetypes = { 'sh', 'bash' },
        },

        -- See: https://github.com/bufbuild/buf-language-server
        bufls = {},

        -- See: https://github.com/mattn/efm-langserver
        efm = {
          init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = true,
          },
        },

        -- See: https://github.com/rust-lang/rust-analyzer
        rust_analyzer = {},

        -- See: https://github.com/redhat-developer/yaml-language-server
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] =
                '/*.k8s.yaml',
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
              },
            },
          },
        },
      },
      signatures = {
        doc_lines = 10,
        hint_enable = false,
        hint_prefix = '',
      },
    },
    config = function(_, opts)
      local capabilities = require('plugins.lsp.capabilities')

      -- enable LSP code actions
      if opts.actions.enabled then
        capabilities.enable_actions({ timeout_ms = opts.actions.timeout_ms })
      end

      -- enable automatic code formatting
      if opts.formatting.enabled then
        capabilities.enable_formatting()
      end

      -- setup keymaps and signature help
      require('plugins.lsp.util').on_attach(function(_, bufnr)
        require('lsp_signature').on_attach(opts.signatures, bufnr)
        require('plugins.lsp.keymaps').on_attach(bufnr)
      end)

      local register_capability = vim.lsp.handlers['client/registerCapability']

      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local bufnr = vim.api.nvim_get_current_buf()
        require('plugins.lsp.keymaps').on_attach(bufnr)
        return ret
      end

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
        focusable = false,
      })

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
        focusable = false,
      })

      require('lspconfig.ui.windows').default_options = {
        border = 'rounded',
      }

      -- Diagnostics

      -- change the sign column gutter symbols.
      -- see: https://github.com/neovim/nvim-lspconfig/wiki/ui-customization#change-diagnostic-symbols-in-the-sign-column-gutter
      for name, icon in pairs(opts.diagnostics.signs) do
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics.settings))

      -- LSP Servers

      -- create a new client capabilities table that will be used to merge with
      -- client specific options.
      local client_capabilities = capabilities.make_client_capabilities(opts.capabilities)

      -- create a new setup function that will merge the default capabilities
      -- with the ones that are passed in.
      local function setup(server)
        local server_opts = require('util').tbl_merge({
          capabilities = vim.deepcopy(client_capabilities),
        }, opts.servers[server] or {})

        require('lspconfig')[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
      end

      -- setup all the servers that have been provided configuration, but either
      -- have been installed manually or cannot be installed with
      -- mason-lspconfig.
      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      -- setup servers that have been installed with mason-lspconfig.
      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
    end,
  },

  -------------
  --- mason ---
  -------------

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
    cmd = {
      'Mason',
      'MasonInstall',
      'MasonLog',
      'MasonUninstall',
      'MasonUninstallAll',
      'MasonUpdate',
    },
    opts = {
      core = {
        ui = {
          border = 'rounded',
          icons = {
            package_installed   = '✓',
            package_pending     = '➜',
            package_uninstalled = '✗',
          },
        },
      },
      lspconfig = {
        -- A list of servers to automatically install if they're not already
        -- installed.
        ensure_installed = {
          'shfmt',
          'stylua',
        },
      },
    },
    config = function(_, opts)
      require('mason').setup(opts.core)
      require('mason-lspconfig').setup(opts.lspconfig)
    end,
  },
}
