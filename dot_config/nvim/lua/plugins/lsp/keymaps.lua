-- -*-mode:vimrc-*- vim:ft=lua

-- ~/.config/nvim/lua/plugins/lsp/keymaps.lua
-- ============================================================================
-- Keymaps for the LSP client.

local util = require('util')

local M = {}

function M.on_attach(bufnr)
  M.lsp_keymaps(bufnr)
  M.diagnostic_keymaps(bufnr)
end

function M.lsp_keymaps(bufnr)
  local map = vim.keymap.set

  local options = function(desc)
    return { buffer = bufnr, desc = desc, noremap = true, nowait = true, silent = true }
  end

  local toggle_inlay_hints = function()
    local inlay_hint = vim.lsp.inlay_hint
    if inlay_hint then
      inlay_hint.enable(not inlay_hint.is_enabled({ bufnr }), { bufnr })
    end
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions.

  -- show hover information for the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspHover', vim.lsp.buf.hover, {})
  map('n', 'K', vim.lsp.buf.hover, options('Hover'))

  -- go to the definition of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspDef', vim.lsp.buf.definition, {})
  map('n', 'gd', vim.lsp.buf.definition, options('Go to definition'))

  -- go to the declaration of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspDec', vim.lsp.buf.declaration, {})
  map('n', 'gD', vim.lsp.buf.declaration, options('Go To declaration'))

  -- toggle inlay hints.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspInlayHints', toggle_inlay_hints, {})
  map('n', 'gh', toggle_inlay_hints, options('Toggle inlay hints'))

  -- go to the implementation of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspImplementation', vim.lsp.buf.implementation, {})
  map('n', 'gI', vim.lsp.buf.implementation, options('Search implementations'))

  -- show the signature of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspSignature', vim.lsp.buf.signature_help, {})
  map({ 'n', 'i' }, '<C-h>', vim.lsp.buf.signature_help, options('Signature help'))

  -- show references to the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspRefs', vim.lsp.buf.references, {})
  map('n', 'gr', vim.lsp.buf.references, options('Search references'))

  -- go to the type definition of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspTypeDef', vim.lsp.buf.type_definition, {})
  map('n', 'gy', vim.lsp.buf.type_definition, options('Go to t[y]pe definition'))

  -- run code actions on the current line or visual selection.
  -- Why `gz`? Both `ga` and `gA` are already taken by the align plugin.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspCodeAction', util.wrap(vim.lsp.buf.code_action), {})
  map({ 'n', 'v' }, 'gz', vim.lsp.buf.code_action, options('Code action'))

  -- rename the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspRename', util.wrap(vim.lsp.buf.rename), {})
  map('n', 'gm', vim.lsp.buf.rename, options('Rena[m]e'))
end

function M.diagnostic_keymaps(bufnr)
  local map = vim.keymap.set

  local options = function(desc)
    return { buffer = bufnr, desc = desc, noremap = true, nowait = true, silent = true }
  end

  -- Buffer local mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions.

  -- open the diagnostic quickfix buffer.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticsQuickfix', vim.diagnostic.setqflist, {})
  map('n', '<C-q>', vim.diagnostic.setqflist, options('Open'))

  -- go to the next diagnostic.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNext', vim.diagnostic.goto_next, {})
  map('n', ']d', vim.diagnostic.goto_next, options('Go to next issue'))

  -- go to the previous diagnostic.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrev', vim.diagnostic.goto_prev, {})
  map('n', '[d', vim.diagnostic.goto_prev, options('Go to previous issue'))

  -- go to the next diagnostic error.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNextError', M.goto_next_error, {})
  map('n', ']e', M.goto_next_error, options('Go to next error'))

  -- go to the previous diagnostic error.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrevError', M.goto_prev_error, {})
  map('n', '[e', M.goto_prev_error, options('Go to previous error'))

  -- go to the next diagnostic warning.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNextWarning', M.goto_next_warning, {})
  map('n', ']w', M.goto_next_warning, options('Go to next warning'))

  -- go to the previous diagnostic warning.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrevWarning', M.goto_prev_warning, {})
  map('n', '[w', M.goto_prev_warning, options('Go to previous warning'))
end

function M.goto_next_error()
  return vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end

function M.goto_prev_error()
  return vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end

function M.goto_next_warning()
  return vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end

function M.goto_prev_warning()
  return vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end

function M.goto_next_info()
  return vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO })
end

function M.goto_prev_info()
  return vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.INFO })
end

function M.goto_next_hint()
  return vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
end

function M.goto_prev_hint()
  return vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT })
end

return M
