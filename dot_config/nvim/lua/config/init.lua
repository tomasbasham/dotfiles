-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/init.lua
-- ============================================================================
-- Initialisation file for the TangoBravo Neovim configuration.

local M = {}

function M.setup()
  -- always load these files first, so that they are available to other
  -- modules. These cannot be lazy loaded.
  M.load('options')
  M.load('colors')
  M.load('session')

  -- if the user did not specify any files for vim to open, the `autocmds` and
  -- `keymaps` modules will be loaded (very) lazily. Otherwise, they will be
  -- loaded immediately.
  if vim.fn.argc(-1) == 0 then
    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('TangoBravo', { clear = true }),
      pattern = 'VeryLazy',
      callback = function()
        M.load('autocmds')
        M.load('keymaps')
      end,
    })
  else
    M.load('autocmds')
    M.load('keymaps')
  end
end

--- Loads a file, catching any errors and printing them to the screen.
---
---@param name string The name of the file to load.
function M.load(name)
  local util = require('lazy.core.util')
  util.try(function()
    require('config.' .. name)
  end, {
    msg = 'Failed loading ' .. name,
    on_error = function(msg)
      local info = require('lazy.core.cache').find(name)
      if info == nil or (type(info) == 'table' and #info == 0) then
        return
      end
      util.error(msg)
    end,
  })
  local pattern = 'TangoBravo' .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

return M
