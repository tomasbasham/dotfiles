-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/init.lua
-- ============================================================================
-- Extra options for vim text editor.
--
-- Sources:
--   https://github.com/bravoecho/dotfiles/blob/main/dotfiles/vimrc

-- Install package manager.
-- See: https://github.com/folke/lazy.nvim
-- See: `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load base configuration.
require('tangobravo').setup()

-- Install plugins. Each plugin is configured in a separate file in the
-- `lua/plugins` directory. This allows for easy organization and configuration
-- of plugins.
require('lazy').setup({
  spec = {
    { import = 'plugins' },

    -- Extra plugins.
    { import = 'plugins.extras.coding' },
    { import = 'plugins.extras.lang' },
    { import = 'plugins.extras.testing' },
  },
  -- Disable change detection. This prevent the annoying "Press ENTER to
  -- continue" prompt.
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = nil, -- we define our own colorscheme.
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'man',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    border = "rounded",
    icons = {
      cmd = '',
      config = '',
      event = '',
      ft = '',
      init = '',
      import = '',
      keys = '',
      lazy = '',
      plugin = '',
      runtime = '',
      source = "",
      start = '',
      list = { '➜' },
    },
  },
})

-- Support legacy vimscript configuration. Use of this feature is discouraged.
vim.opt.rtp:prepend('~/.vim')
vim.opt.rtp:append('~/.vim/after')

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  command = 'source ~/.vimrc',
})
