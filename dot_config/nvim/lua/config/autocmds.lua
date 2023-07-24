-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/autocmds.lua
-- ============================================================================
-- Additional autocmds to control various aspects of Neovim.

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--------------
--- Cursor ---
--------------

local ignore_buftypes = { 'quickfix', 'nofile', 'help' }
local ignore_filetypes = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' }

autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.tbl_contains(ignore_filetypes, vim.opt_local.filetype:get()) then
      return
    end

    if vim.tbl_contains(ignore_buftypes, vim.opt_local.buftype:get()) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-------------------
--- Diagnostics ---
-------------------

local function generate_paths(name)
  return {
    string.format('**/%s/**', name),
    name,
    string.format('/%s/*', name),
  }
end

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = vim.tbl_flatten({
    generate_paths('.bundle'),
    generate_paths('.direnv'),
    generate_paths('node_modules'),
    generate_paths('vendor'),
  }),
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

----------------------
--- Line Numbering ---
----------------------

local function enable_relative_line_numbers()
  local is_insert_mode = vim.api.nvim_get_mode().mode == 'i'
  if vim.opt_local.number:get() and not is_insert_mode then
    vim.opt_local.rnu = true
  end
end

local function disable_relative_line_numbers()
  if vim.opt_local.number:get() then
    vim.opt_local.rnu = false
  end
end

local number_toggle = augroup('number_toggle', { clear = true })

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  pattern = '*',
  group = number_toggle,
  callback = enable_relative_line_numbers,
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  pattern = '*',
  group = number_toggle,
  callback = disable_relative_line_numbers,
})

----------------
--- Quickfix ---
----------------

-- force quickfix to always use the full width of the terminal at the bottom
-- (and only the quickfix, not the location list, which instead belongs to each
-- specific buffer)
--
-- https://stackoverflow.com/a/59823132/417375
local function quickfix_at_the_bottom()
  local win_id = vim.api.nvim_get_current_win()
  if vim.fn.getwininfo(win_id)[1].loclist == 0 then
    vim.cmd.wincmd('J')
  end
end

autocmd('Filetype', {
  pattern = 'qf',
  callback = quickfix_at_the_bottom,
})

------------------
--- Whitespace ---
------------------

local s_end_of_lines = [[%s/\s\+$//e]]
local s_end_of_file = [[%s/\($\n\s*\)\+\%$//]]
local s_multiple_lines = [[%s/\n\{3,}/\r\r/e]]

local function replace_with(pattern)
  vim.api.nvim_exec(string.format('keepjumps keeppatterns silent! %s', pattern), false)
end

local filetypes_no_extra_whitespace = {
  'Dockerfile',
  'bash',
  'gitconfig',
  'html',
  'javascript',
  'json',
  'lua',
  'make',
  'php',
  'ruby',
  'sh',
  'sql',
  'text',
  'tmux',
  'terraform',
  'toml',
  'typescript',
  'vim',
  'yaml',
  'zsh',
}

local filetypes_no_trailing_whitespace = {
  'python',
  'bzl',
}

local function trim_extra_whitespace()
  local winview = vim.fn.winsaveview()

  replace_with(s_end_of_lines)
  replace_with(s_end_of_file)
  replace_with(s_multiple_lines)

  vim.fn.winrestview(winview)
end

local function trim_trailing_whitespace()
  local winview = vim.fn.winsaveview()

  replace_with(s_end_of_lines)
  replace_with(s_end_of_file)

  vim.fn.winrestview(winview)
end

local function strip_whitespace()
  local ft = vim.opt_local.ft:get()
  if vim.tbl_contains(filetypes_no_extra_whitespace, ft) then
    trim_extra_whitespace()
    return
  end

  if vim.tbl_contains(filetypes_no_trailing_whitespace, ft) then
    trim_trailing_whitespace()
    return
  end
end

local trim_augroup = augroup('WhitespaceTrim', { clear = true })

autocmd('BufWritePre', {
  pattern = '*',
  group = trim_augroup,
  callback = strip_whitespace,
})

vim.api.nvim_create_user_command('WhitespaceTrimExtra', trim_extra_whitespace, {})
vim.api.nvim_create_user_command('WhitespaceTrimTrailing', trim_trailing_whitespace, {})
