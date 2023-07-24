-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/config/colors.lua
-- ============================================================================
-- Colour scheme and highlight groups.

local black         = { term = 0, gui = '#262525' }
local red           = { term = 1, gui = '#eba080' }
local green         = { term = 2, gui = '#a5b167' }
local yellow        = { term = 3, gui = '#cba953' }
local blue          = { term = 4, gui = '#76bee2' }
local magenta       = { term = 5, gui = '#b5a9db' }
local cyan          = { term = 6, gui = '#79bcc7' }
local grey          = { term = 7, gui = '#939292' }

local brightblack   = { term = 8, gui = '#3e3e3e' }
local brightred     = { term = 9, gui = '#ff7d7d' }
local brightgreen   = { term = 10, gui = '#70b16f' }
local brightyellow  = { term = 11, gui = '#e4a33f' }
local brightblue    = { term = 12, gui = '#81d2e3' }
local brightmagenta = { term = 13, gui = '#e7a8ce' }
local brightcyan    = { term = 14, gui = '#65cdbb' }
local white         = { term = 15, gui = '#bbbbbb' }

-- Set attributes for a highlight group.
---@param group string The highlight group.
---@param opts table Attributes to be set on the highlight group.
local function hl(group, opts)
  local opts_copy = require('util').tbl_copy(opts)

  if opts.fg ~= nil then
    opts_copy.ctermfg = opts.fg.term
    opts_copy.fg = opts.fg.gui
  end

  if opts.bg ~= nil then
    opts_copy.ctermbg = opts.bg.term
    opts_copy.bg = opts.bg.gui
  end

  vim.api.nvim_set_hl(0, group, opts_copy)
end

-- Set attributes for a highlight group and implicity set the `default`
-- attribute to `true`.
--
-- @see https://github.com/nvim-treesitter/nvim-treesitter/commit/42ab95d5e11f247c6f0c8f5181b02e816caa4a4f#commitcomment-87014462
-- @see https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights
-- @see :h treesitter-highlight-groups
--
---@param group string The highlight group.
---@param opts table Attributes to be set on the highlight group.
local hld = function(group, opts)
  opts.default = true
  hl(group, opts)
end

-- Nvim emits true (24-bit) colours in the terminal, if 'termguicolors' is set.
-- This must be disabled if we are to work with the 16 colours defined by the
-- terminal emulator profile.
vim.opt.termguicolors = false

----------------
--- Built-in ---
----------------

local diagnostic_sign_err_fg = brightred
local diagnostic_sign_warn_fg = brightyellow
local diagnostic_sign_info_fg = blue
local diagnostic_sign_hint_fg = green

hl('Boolean', { link = 'Constant' })
hl('Character', { link = 'Constant' })
hl('ColorColumn', { bg = black })
hl('Comment', { fg = grey, italic = true })
hl('Conceal', { fg = grey, bg = brightblack })
hl('Conditional', { link = 'Statement' })
hl('Constant', { fg = brightyellow })
hl('CurSearch', { fg = brightyellow, reverse = true })
hl('CursorColumn', { bg = brightblack })
hl('CursorLine', { bg = black })
hl('CursorLineNr', { fg = white, bg = black })
hl('CursorLineSign', { link = 'SignColumn' })
hl('Debug', { link = 'Special' })
hl('Define', { link = 'PreProc' })
hl('Delimiter', { fg = brightred })
hl('DiagnosticError', { fg = red, italic = true })
hl('DiagnosticSignError', { fg = diagnostic_sign_err_fg })
hl('DiagnosticWarn', { fg = yellow, italic = true })
hl('DiagnosticSignWarn', { fg = diagnostic_sign_warn_fg })
hl('DiagnosticInfo', { fg = blue, italic = true })
hl('DiagnosticSignInfo', { fg = diagnostic_sign_info_fg })
hl('DiagnosticHint', { fg = green, italic = true })
hl('DiagnosticSignHint', { fg = diagnostic_sign_hint_fg })
hl('DiffAdd', { fg = green, bg = brightblack })
hl('DiffChange', { fg = white, bg = brightblack })
hl('DiffDelete', { fg = red, bg = brightblack })
hl('DiffText', { fg = blue, bg = brightblack })
hl('Directory', { fg = blue })
hl('EndOfBuffer', { fg = black })
hl('Error', { fg = red })
hl('ErrorMsg', { fg = brightred, italic = true })
hl('Exception', { link = 'Statement' })
hl('Float', { link = 'Number' })
hl('FloatBorder', { fg = grey, bg = black })
hl('FoldColumn', { fg = blue, bg = black })
hl('Folded', { bg = black })
hl('Function', { fg = magenta })
hl('Identifier', { fg = blue })
hl('Ignore', { fg = black })
hl('IncSearch', { link = 'Search' })
hl('Include', { link = 'PreProc' })
hl('Keyword', { link = 'Statement' })
hl('Label', { link = 'Statement' })
hl('LineNr', { fg = grey })
hl('LineNrAbove', { link = 'LineNr' })
hl('LineNrBelow', { link = 'LineNr' })
hl('Macro', { link = 'PreProc' })
hl('MatchParen', { fg = brightblue, bg = brightblack })
hl('ModeMsg', { bold = false })
hl('MoreMsg', { fg = brightgreen })
hl('NonText', { fg = grey })
hl('Normal', {})
hl('NormalFloat', { ctermbg = 0 })
hl('Number', { link = 'Constant' })
hl('Operator', { link = 'Statement' })
hl('Pmenu', { bg = brightblack })
hl('PmenuSbar', { bg = brightblack })
hl('PmenuSel', { fg = blue, bg = black, reverse = true })
hl('PmenuThumb', { bg = grey })
hl('PreCondit', { link = 'PreProc' })
hl('PreProc', { fg = brightblue })
hl('Question', { fg = brightgreen })
hl('QuickFixLine', { link = 'CursorLine' })
hl('Repeat', { link = 'Statement' })
hl('Search', { fg = black, bg = blue })
hl('SignColumn', { link = 'LineNr' })
hl('Special', { fg = red })
hl('SpecialChar', { link = 'Special' })
hl('SpecialComment', { link = 'Special' })
hl('SpecialKey', { fg = brightblue })
hl('SpellBad', { fg = red, bg = black, underline = true })
hl('SpellCap', { fg = brightblue, bg = black, underline = true })
hl('SpellLocal', { fg = brightcyan, bg = black, underline = true })
hl('SpellRare', { fg = brightmagenta, bg = black, underline = true })
hl('Statement', { fg = yellow })
hl('StatusLine', { fg = white, bg = brightblack })
hl('StatusLineNC', { fg = grey, bg = black })
hl('StatusLineTerm', { fg = black, bg = brightgreen })
hl('StatusLineTermNC', { fg = black, bg = brightgreen })
hl('StorageClass', { link = 'Type' })
hl('String', { fg = green })
hl('Structure', { link = 'Type' })
hl('TabLine', { link = 'StatusLineNC' })
hl('TabLineFill', { link = 'StatusLineNC' })
hl('TabLineSel', { fg = blue, bg = black })
hl('Tag', { link = 'Special' })
hl('Title', { fg = brightmagenta })
hl('Todo', { fg = blue, italic = true, underline = true })
hl('ToolbarButton', { fg = black, bg = grey })
hl('ToolbarLine', { bg = brightblack })
hl('Type', { fg = brightgreen })
hl('Typedef', { fg = cyan })
hl('Underlined', { fg = brightblue, underline = true })
hl('VertSplit', { fg = white })
hl('Visual', { bg = brightblack })
hl('VisualNOS', { underline = true })
hl('WarningMsg', { fg = yellow })
hl('WildMenu', { fg = black, bg = brightyellow })

---------------
--- fzf-lua ---
---------------

hl('FzfLuaNormal', { link = 'NormalFloat' })
hl('FzfLuaBorder', { link = 'FloatBorder' })

------------------
--- lsp-config ---
------------------

hl('LspInfoBorder', { link = 'FloatBorder' })

----------------
--- nvim-cmp ---
----------------

hld('CmpGhostText', { link = 'Comment' })

----------------
--- nvim-dap ---
----------------

hld('DapStoppedLine', { link = 'Visual' })

-----------------
--- nvim-tree ---
-----------------

-- invisible statusline.
hl('NvimTreeStatusLine', { fg = brightblack, bg = brightblack })
hl('NvimTreeStatusLineNC', { fg = black, bg = black })

--------------------------
--- treesitter-context ---
--------------------------

hl('TreesitterContext', { bg = brightblack, underline = true })
hl('TreesitterContextLineNumber', { fg = brightcyan, bg = brightblack, underline = true })

--------------------------------------
--- Translate Treesitter to Legacy ---
--------------------------------------

hld('@attribute', { link = 'PreProc' })
hld('@function.call', { link = 'Function' })
hld('@keyword.function', { link = 'Keyword' })
hld('@keyword.operator', { link = 'Keyword' })
hld('@keyword.return', { link = 'Keyword' })
hld('@method.call', { link = 'Function' })
hld('@namespace', { link = 'Include' })
hld('@none', {})
hld('@punctuation.bracket', { link = 'Delimiter' })
hld('@punctuation.delimiter', { link = 'Delimiter' })
hld('@punctuation.special', { link = 'Delimiter' })
hld('@string.regex', { link = 'String' })
hld('@symbol', { link = 'Identifier' })
hld('@tag.attribute', { link = 'Identifier' })
hld('@tag.delimiter', { link = 'Delimiter' })
hld('@text', { link = 'Normal' })
hld('@text.danger', { link = 'ErrorMsg' })
hld('@text.diff.add', { link = 'DiffAdd' })
hld('@text.diff.change', { link = 'DiffChange' })
hld('@text.diff.delete', { link = 'DiffDelete' })
hld('@text.diff.text', { link = 'DiffText' })
hld('@text.emphasis', { italic = true })
hld('@text.environment', { link = 'Macro' })
hld('@text.environment.name', { link = 'Type' })
hld('@text.literal', { link = 'String' })
hld('@text.math', { link = 'Special' })
hld('@text.note', { link = 'SpecialComment' })
hld('@text.reference', { link = 'Constant' })
hld('@text.strike', { strikethrough = true })
hld('@text.strong', { bold = true })
hld('@text.underline', { underline = true })
hld('@text.warning', { link = 'WarningMsg' })
hld('@type.builtin', { link = 'Type' })
hld('@type.definition', { link = 'Typedef' })
hld('@type.qualifier', { link = 'Type' })
hld('@variable', { link = 'Normal' })
hld('@variable.builtin', { link = 'Special' })
hld('@variable.bash', { link = 'Constant' })

---------------------------------
--- Treesitter customisations ---
---------------------------------

-- Hide all semantic highlights, instead of disabling semantic tokens all
-- together. For disabling semantic tokens, see user/lsp.lua
--
-- See also
--
--   * :h lsp-semantic-highlight
--   * https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
--   * https://vi.stackexchange.com/questions/41931/how-to-disable-semantic-highlighting-for-certain-filetypes-only
--
-- Printing the groups we get a slightly different result to the list from the
-- help page. They include "comment", which is not listed by the docs.
--
--     Printing                  | Default mapping links to...
--     -------------------------------------------------------
--     @lsp.type.class             Structure
--     @lsp.type.comment           Comment
--     @lsp.type.decorator         Function
--     @lsp.type.enum              Structure
--     @lsp.type.enumMember        Constant
--     @lsp.type.function          Function
--     @lsp.type.interface         Structure
--     @lsp.type.macro             Macro
--     @lsp.type.method            Function
--     @lsp.type.namespace         Structure
--     @lsp.type.parameter         Identifier
--     @lsp.type.property          Identifier
--     @lsp.type.struct            Structure
--     @lsp.type.type              Type
--     @lsp.type.typeParameter     TypeDef
--     @lsp.type.variable          Identifier
--
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   -- vim.print(group)
--   -- vim.api.nvim_set_hl(0, group, {})
-- end

vim.api.nvim_set_hl(0, '@lsp.type.comment', {})
vim.api.nvim_set_hl(0, '@lsp.type.function', {})
vim.api.nvim_set_hl(0, '@lsp.type.variable', {})

----------------
--- Markdown ---
----------------

hld('@text.quote.markdown', { italic = true })
hld('@text.title.1.markdown', { fg = brightred })
hld('@text.title.1.marker.markdown', { fg = red })
hld('@text.title.2.markdown', { fg = magenta })
hld('@text.title.2.marker.markdown', { fg = brightmagenta })
hld('@text.title.3.markdown', { fg = blue, underline = true })
hld('@text.title.4.markdown', { fg = blue, underline = true })
hld('@text.title.5.markdown', { fg = blue, underline = true })
hld('@text.title.6.markdown', { fg = blue, underline = true })
hld('@text.title.3.marker.markdown', { fg = brightblue, underline = true })
hld('@text.title.4.marker.markdown', { fg = brightblue, underline = true })
hld('@text.title.5.marker.markdown', { fg = brightblue, underline = true })
hld('@text.title.6.marker.markdown', { fg = brightblue, underline = true })
