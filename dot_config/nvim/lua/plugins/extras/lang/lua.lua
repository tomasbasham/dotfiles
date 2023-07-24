return {

  ------------------
  --- treesitter ---
  ------------------

  {
    'nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'lua',
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

        -- See: https://github.com/LuaLS/lua-language-server
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                -- get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              hint = {
                enable = true,
                arrayIndex = 'Enable',
                await = true,
                paramName = 'All',
                paramType = true,
                semicolon = 'Disable',
                setType = true,
                table = true,
                typeParameterName = 'Disable',
              },
              runtime = {
                version = 'LuaJIT',
              },
              -- do not send telemetry data containing a randomized but unique
              -- identifier
              telemetry = {
                enable = false,
              },
              workspace = {
                -- make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
  },
}
