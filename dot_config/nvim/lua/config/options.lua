-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/options.lua
-- ============================================================================
-- Vim native options.

vim.scriptencoding = 'utf-8'

-- Set <space> as the leader key.
-- See: `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Eagerly disable netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Ignore some unused language integrations, to silence the corresponding
-- warnings in :checkhelth.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- Securely enable .nvim.lua, .nvimrc and .vimrc for current workspace.
opt.exrc = true
opt.secure = true

-- Global options.
opt.autoindent = true                            -- Copy indent from current line when starting a new line.
opt.autoread = true                              -- Reload files changed outside vim.
opt.autowrite = true                             -- Enable auto write.
opt.backspace = 'indent,eol,start'               -- Make backspace behave like most other apps.
opt.breakindent = true                           -- Align visually wrapped lines with the original indentation.
opt.clipboard = 'unnamedplus'                    -- Sync with system clipboard.
opt.colorcolumn = '81,101'                       -- Display vertical columns for text boundaries.
opt.completeopt = 'menu,menuone,noselect'        -- Insert mode completion options.
opt.confirm = true                               -- Confirm to save changes before exiting modified buffer.
opt.cpoptions:append('I')                        -- Do not delete indent.
opt.cursorline = true                            -- Enable highlighting of the current line.
opt.errorbells = false                           -- Disable error bells.
opt.expandtab = true                             -- Use spaces instead of tabs.
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Use treesitter to fold.
opt.formatoptions = 'tcrqnljp'                   -- Set formatting options.
opt.gdefault = true                              -- Replace all occurrences in a line by default.
opt.grepformat = '%f:%l:%c:%m'                   -- Use filename:line:column:error:message format.
opt.grepprg = 'rg --vimgrep'                     -- Use ripgrep for grepping.
opt.hidden = true                                -- Allow hiding a modified buffer.
opt.history = 10000                              -- Store lots of command history.
opt.hlsearch = true                              -- Highlight search results.
opt.ignorecase = true                            -- Ignore case.
opt.inccommand = 'nosplit'                       -- preview incremental substitute.
opt.incsearch = true                             -- Incremental search. Start searching without pressing enter.
opt.joinspaces = true                            -- No double spaces when joining after punctuation.
opt.laststatus = 2                               -- Always display the status line.
opt.lazyredraw = true                            -- Don't redraw while executing macros.
opt.linebreak = true                             -- Break between words when wrapping (don't break within words).
opt.matchpairs:append('<:>')                     -- Add < and > to the list of matching pairs.
opt.matchtime = 0                                -- Don't jump around when matching parentheses.
opt.modeline = true                              -- Enable modeline. Determine filetype from magic comment.
opt.modelines = 3                                -- Number of lines checked for set commands.
opt.mouse = 'a'                                  -- Enable mouse mode.
opt.number = true                                -- Print line number.
opt.pumheight = 10                               -- Maximum number of entries in a popup.
opt.relativenumber = true                        -- Relative line numbers.
opt.scrolloff = 8                                -- Minimum number of screen lines to keep above and below the cursor.
opt.shiftround = true                            -- Round indent.
opt.shiftwidth = 2                               -- Size of an indent.
opt.showcmd = false                              -- Don't show command in statusline.
opt.showmatch = true                             -- Show matching brackets.
opt.showmode = false                             -- Don't show mode since we have a statusline.
opt.sidescroll = 8                               -- Minimum number of columns to scroll horizontally.
opt.sidescrolloff = 8                            -- Minimum number of columns to keep to the left and right of the cursor.
opt.signcolumn = 'yes'                           -- Always show the signcolumn to prevent text shifts.
opt.smartcase = true                             -- Don't ignore case with capitals.
opt.softtabstop = 2                              -- Number of spaces tabs count for (visual).
opt.spelllang = 'en_gb'                          -- Set spelling language to english.
opt.splitbelow = true                            -- Put new windows below current.
opt.splitright = true                            -- Put new windows right of current.
opt.swapfile = true                              -- Enable swap file.
opt.switchbuf = 'useopen'                        -- Prefer jumping to buffers in open windows.
opt.tabstop = 2                                  -- Number of spaces tabs count for (authoritative).
opt.termguicolors = false                        -- Disable true color support.
opt.textwidth = 80                               -- Maximum width of text that is being inserted.
opt.timeout = true                               -- Enable command timeout.
opt.timeoutlen = 400                             -- Reduce the command timeout.
opt.undofile = true                              -- Create and use an undo file.
opt.undolevels = 10000                           -- Maximum number of changes that can be undone.
opt.updatetime = 200                             -- Save swap file and trigger CursorHold.
opt.virtualedit = 'block'                        -- Allow cursor to move beyond the end of the line.
opt.wildignorecase = true                        -- Ignore case when completing file names and directories.
opt.wildmode = 'list:longest,full'               -- Command-line completion mode.
opt.winminwidth = 5                              -- Minimum window width.
opt.wrap = false                                 -- Disable line wrap.
opt.writebackup = true                           -- Enable backup file.

-- Remove the text boundary vertical columns for quickfix and help windows.
vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'qf', 'help', 'loclist' },
  callback = function()
    vim.opt_local.colorcolumn = {}
  end,
})

-- Use # as the comment character for gitconfig files.
vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'gitconfig' },
  callback = function()
    vim.opt_local.commentstring = '# %s'
  end,
})

-- Disabling auto formatting for the following file types because the wrapping
-- also seems to be applied to code.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'erb', 'sh', 'swift' },
  callback = function()
    vim.opt_local.formatoptions:remove('t')
  end,
})

--  Strings to use in 'listchars' and for the `:list` command.
opt.listchars = {
  extends = '>',
  precedes = '<',
  tab = '▸·',
  trail = '·',
}

-- Explicitly set the session options.
opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
}

-- Disable messages.
opt.shortmess:append({
  I = true, -- Don't show intro message when starting vim.
  S = true, -- Show number of matches when searching.
  W = true, -- Don't show "written" when writing to a file.
  c = true, -- Don't show different messages when using completion.
})

-- Automatically enable spell checking for some filetypes.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Name of the word list file where words are added for the zg and zw commands.
-- It must end in ".{encoding}.add".  You need to include the path, otherwise
-- the file is placed in the current directory.
opt.spellfile = vim.env.HOME .. '/.config/nvim/spell/en.utf-8.add'

-- Recompile the personal spell file if newer than the compiled version.
-- Useful when synchronising the spell file with Dropbox or git.
-- https://vi.stackexchange.com/a/5052
for _, p in ipairs(vim.fn.glob(vim.env.HOME .. '/.config/nvim/spell/*.add', true, true)) do
  if vim.fn.filereadable(p) and (not vim.fn.filereadable(p .. '.spl') or vim.fn.getftime(p) > vim.fn.getftime(p .. '.spl')) then
    vim.api.nvim_exec('mkspell! ' .. vim.fn.fnameescape(p), false)
  end
end

-- Possible values are:
--   cursor  Keep the same relative cursor position.
--   screen  Keep the text on the same screen line.
--   topline Keep the topline the same.
local version = vim.version()
if version and (version.major > 0 or version.minor >= 9) then
  vim.opt.splitkeep = 'screen'
end
