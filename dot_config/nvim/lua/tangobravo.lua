-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/tangobravo.lua
-- ============================================================================
-- Entrypoint for the TangoBravo Neovim configuration.

local M = {}

--- Entrypoint for vim configuration.
function M.setup()
  require('config').setup()
end

return M
