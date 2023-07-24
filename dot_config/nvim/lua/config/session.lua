-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/init.lua
-- ============================================================================
-- Session handling. This must be run before any other configuration is loaded
-- otherwise the autocmd will not be triggered.

local autocmd = vim.api.nvim_create_autocmd

local function getSessionFile()
  local sessionfile = vim.fn.stdpath('data') .. '/sessions/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t') .. '.vim'

  if vim.fn.filereadable('Session.vim') == 1 then
    return 'Session.vim', true
  elseif vim.fn.filereadable(sessionfile) == 1 then
    return sessionfile, true
  end

  return '', false
end

-- override an existing session file if it exists.
local function saveSession()
  local sessionfile, exists = getSessionFile()
  if exists then
    vim.api.nvim_exec('mksession! ' .. sessionfile, false)
  end
end

-- restore the session if it exists.
local function restoreSession()
  local sessionfile, exists = getSessionFile()
  if exists then
    vim.api.nvim_exec('source ' .. sessionfile, false)
  else
    print('No session restored.')
  end
end

-- save the session on exit or when leaving a buffer.
autocmd({ 'BufLeave', 'VimLeavePre' }, {
  pattern = '*',
  callback = saveSession,
})

-- restore the session on starting vim.
autocmd('VimEnter', {
  pattern = '*',
  nested = true,
  callback = restoreSession,
})
