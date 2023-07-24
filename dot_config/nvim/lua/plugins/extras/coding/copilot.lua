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
      vim.g.copilot_no_tab_map = true

      local util = require('util')

      -- Set the default node command to use for Copilot. This is useful when
      -- you have multiple versions of Node.js installed on your system.
      --
      -- When used in conjuction with the `direnv` extension, you can use one
      -- node version for the code, and another for Copilot.
      local default_node_binary = util.default_node_binary()
      if default_node_binary then
        vim.g.copilot_node_command = default_node_binary
      end

      local options = {
        expr = true,
        replace_keycodes = false,
        silent = true,
      }

      -- Remap the default <C-]> to accept the current suggestion.
      vim.api.nvim_set_keymap('i', '<C-]>', 'copilot#Accept("\\<CR>")', options)

      -- Sometimes we only want to accept the next word that Copilot suggests.
      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
    end,
  },
}
