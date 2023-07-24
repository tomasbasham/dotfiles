return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'tsx',
        'typescript',
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
        -- See: https://github.com/Microsoft/vscode-eslint
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },

        -- See: https://github.com/microsoft/vscode-json-languageservice
        jsonls = {},

        -- See: https://github.com/typescript-language-server/typescript-language-server
        ts_ls = {
          settings = {
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              preferences = {
                importModuleSpecifier = 'non-relative'
              },
            },
          },
        },
      },
    },
  },
}
