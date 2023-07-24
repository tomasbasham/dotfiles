-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/keymaps.lua
-- ============================================================================
-- Vim global keymaps.

local map = vim.keymap.set

-- search word under cursor without moving cursor (case insensitive).
map({ 'n', 'x' }, 'gs', '*N', { desc = 'Search word under cursor', silent = true })

-- clear search with <esc>.
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- swap lines.
map('n', '<C-j>', '<cmd>m .+1<cr>==', { desc = 'Move down', silent = true })
map('n', '<C-k>', '<cmd>m .-2<cr>==', { desc = 'Move up', silent = true })
map('i', '<C-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down', silent = true })
map('i', '<C-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up', silent = true })
map('v', '<C-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down', silent = true })
map('v', '<C-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up', silent = true })

-- indent/unindent visually selected lines without losing selection.
map('v', '<', '<gv', { desc = 'Unindent' })
map('v', '>', '>gv', { desc = 'Indent' })

-- indent/unindent current line with a single key stroke.
map('n', '<', '<<', { desc = 'Unindent' })
map('n', '>', '>>', { desc = 'Indent' })

-- save file.
map({ 'i', 'v', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
map({ 'i', 'v', 'n', 's' }, '<C-\\>', '<cmd>noa w<cr><esc>', { desc = 'Save file (no format)' })

-- open quickfix and location list.
map('n', '<leader>xl', vim.cmd.lopen, { desc = 'Open location list' })
map('n', '<leader>xq', vim.cmd.copen, { desc = 'Open quickfix list' })

-- navigate quickfix and location list.
map('n', ']q', vim.cmd.cnext, { desc = 'Go to next', silent = true })
map('n', '[q', vim.cmd.cprevious, { desc = 'Go to previous', silent = true })
map('n', ']l', vim.cmd.lnext, { desc = 'Go to next', silent = true })
map('n', '[l', vim.cmd.lprevious, { desc = 'Go to previous', silent = true })

-- close current buffer without closing the window.
map('n', '<leader>q', '<cmd>bp|sp|bn|bd<cr>', { desc = 'Close buffer', silent = true })

-- toggle paste mode.
map('n', '<F3>', '<cmd>setlocal paste!<cr>', { desc = 'Toggle paste mode', silent = true })

-- toggle between buffers.
map('n', '<leader><leader>', '<C-^>', { desc = 'Toggle between buffers' })

-- make shift-y consistent with shift-c and shift-d.
map('n', 'Y', 'y$', { desc = 'Yank to end of line' })

-- avoid opening the command history.
-- use :<C-f> instead.
map('n', 'q:', '<nop>', { silent = true })

-- remap Ex mode to "formatting".
map('x', 'Q', 'gq', { desc = 'Formatting' })

-- toggle line wrapping.
map('n', '<leader>w', '<cmd>set wrap!<cr>', { desc = 'Toggle line wrapping' })

-- toggle spelling.
map({ 'n', 'x' }, '<F6>', '<cmd>setlocal spell!<cr>', { desc = 'Toggle spelling', noremap = true, silent = true })
map('i', '<F6>', '<esc><cmd>setlocal spell!<cr>', { desc = 'Toggle spelling', noremap = true, silent = true })

-- paste over visual selection preserving content in the paste buffer.
map('x', 'p', '"_dP', { desc = 'Paste', noremap = true })
map('x', '<Leader>p', "p", { desc = 'Paste', noremap = true })

-- delete visual selection preserving content in the paste buffer.
map('n', '<A-d>', '"_dd', { desc = 'Delete', noremap = true })
map('x', '<A-d>', '"_d', { desc = 'Delete', noremap = true })
map('n', '^[d', '"_dd', { desc = 'Delete', noremap = true })
map('x', '^[d', '"_d', { desc = 'Delete', noremap = true })

-- cut visual selection preserving content in the paste buffer.
map({ 'n', 'x' }, 'x', '"_x', { desc = 'Cut', noremap = true })

-- search and replace current word.
map('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/', { desc = 'Replace word under cursor', noremap = true })

-- tmux navigation.
local function tmux_wincmd(direction)
  local wnr = vim.fn.winnr()
  -- try to move...
  vim.cmd.wincmd(direction)
  -- ...and if does nothing it means that it was the last vim pane, so we
  -- forward the command back to tmux
  if wnr == vim.fn.winnr() then
    vim.fn.system('tmux select-pane -' .. vim.fn.tr(direction, 'phjkl', 'lLDUR'))
  end
end

local function tmux_wincmd_left()
  tmux_wincmd('h')
end

local function tmux_wincmd_down()
  tmux_wincmd('j')
end

local function tmux_wincmd_up()
  tmux_wincmd('k')
end

local function tmux_wincmd_right()
  tmux_wincmd('l')
end

-- map to arrow keys.
map('n', '<M-Left>', tmux_wincmd_left, { desc = 'Window left' })
map('n', '<M-Down>', tmux_wincmd_down, { desc = 'Window down' })
map('n', '<M-Up>', tmux_wincmd_up, { desc = 'Window up' })
map('n', '<M-Right>', tmux_wincmd_right, { desc = 'Window right' })

-- map to common vim direction keys.
map('n', '<M-h>', tmux_wincmd_left, { desc = 'Window left' })
map('n', '<M-j>', tmux_wincmd_down, { desc = 'Window down' })
map('n', '<M-k>', tmux_wincmd_up, { desc = 'Window up' })
map('n', '<M-l>', tmux_wincmd_right, { desc = 'Window right' })
