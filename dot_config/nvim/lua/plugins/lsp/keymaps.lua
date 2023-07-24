local M = {}

function M.on_attach(bufnr)
  M.lsp_keymaps(bufnr)
  M.diagnostic_keymaps(bufnr)
end

function M.lsp_keymaps(bufnr)
  local map = vim.keymap.set

  local options = function(desc)
    return { buffer = bufnr, desc = 'Lsp: ' .. desc, noremap = true, nowait = true, silent = true }
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
  map('n', 'gd', vim.lsp.buf.definition, options('Go to Definition'))

  -- go to the declaration of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspDec', vim.lsp.buf.declaration, {})
  map('n', 'gD', vim.lsp.buf.declaration, options('Go To Declaration'))

  -- go to the implementation of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspImplementation', vim.lsp.buf.implementation, {})
  map('n', 'gi', vim.lsp.buf.implementation, options('Go to Implementation'))

  -- show the signature of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspSignature', vim.lsp.buf.signature_help, {})
  map('n', 'gh', vim.lsp.buf.signature_help, options('Signature Help'))
  map('i', '<C-h>', vim.lsp.buf.signature_help, options('Signature Help'))

  -- show references to the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspRefs', vim.lsp.buf.references, {})
  map('n', 'gr', vim.lsp.buf.references, options('Find References'))

  -- go to the type definition of the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspTypeDef', vim.lsp.buf.type_definition, {})
  map('n', 'gy', vim.lsp.buf.type_definition, options('Go to T[y]pe Definition'))

  -- run code actions on the current line or visual selection.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspCodeAction', vim.lsp.buf.code_action, {})
  map({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, options('Code Action'))

  -- rename the symbol under the cursor.
  vim.api.nvim_buf_create_user_command(bufnr, 'LspRename', vim.lsp.buf.rename, {})
  map('n', '<Leader>rn', vim.lsp.buf.rename, options('Rename'))
end

function M.diagnostic_keymaps(bufnr)
  local map = vim.keymap.set

  local options = function(desc)
    return { buffer = bufnr, desc = 'Diagnostics: ' .. desc, noremap = true, nowait = true, silent = true }
  end

  -- Buffer local mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions.

  -- open the diagnostic quickfix buffer.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticsQuickfix', vim.diagnostic.setqflist, {})
  map('n', '<C-q>', vim.diagnostic.setqflist, options('Open'))

  -- go to the next diagnostic.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNext', vim.diagnostic.goto_next, {})
  map('n', ']d', vim.diagnostic.goto_next, options('Go to Next'))

  -- go to the previous diagnostic.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrev', vim.diagnostic.goto_prev, {})
  map('n', '[d', vim.diagnostic.goto_prev, options('Go to Previous'))

  -- go to the next diagnostic error.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNextError', M.goto_next_error, {})
  map('n', ']e', M.goto_next_error, options('Go to Next Error'))

  -- go to the previous diagnostic error.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrevError', M.goto_prev_error, {})
  map('n', '[e', M.goto_prev_error, options('Go to Previous Error'))

  -- go to the next diagnostic warning.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticNextWarning', M.goto_next_warning, {})
  map('n', ']w', M.goto_next_warning, options('Go to Next Warning'))

  -- go to the previous diagnostic warning.
  vim.api.nvim_buf_create_user_command(bufnr, 'DiagnosticPrevWarning', M.goto_prev_warning, {})
  map('n', '[w', M.goto_prev_warning, options('Go to Previous Warning'))
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
