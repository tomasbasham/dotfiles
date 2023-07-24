return {
  {
    'github/copilot.vim',
    build = ':Copilot auth',
    enabled = true,
    event = {
      'InsertEnter',
      'LspAttach',
    },
    config = function()
      local options = { expr = true, silent = true }
      vim.api.nvim_set_keymap('i', '<C-]>', 'copilot#Accept("<CR>")', options)
    end,
  },
  -- {
  --   'zbirenbaum/copilot.lua',
  --   build = ':Copilot auth',
  --   cmd = 'Copilot',
  --   enabled = false,
  --   event = {
  --     'InsertEnter',
  --     'LspAttach',
  --   },
  --   opts = {
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --     panel = {
  --       enabled = false,
  --     },
  --     suggestion = {
  --       enabled = false,
  --     },
  --   },
  -- },
  -- {
  --   'nvim-cmp',
  --   dependencies = {
  --     'zbirenbaum/copilot-cmp',
  --     dependencies = 'zbirenbaum/copilot.lua',
  --     opts = {},
  --     config = function(_, opts)
  --       local copilot_cmp = require('copilot_cmp')
  --       copilot_cmp.setup(opts)

  --       require('plugins.lsp.util').on_attach(function(client)
  --         if client.name == 'copilot' then
  --           copilot_cmp._on_insert_enter({})
  --         end
  --       end)
  --     end,
  --   },
  --   enabled = true,
  --   opts = function(_, opts)
  --     table.insert(opts.sources, 1, { name = 'copilot', group_index = 2 })
  --   end,
  -- },
}
