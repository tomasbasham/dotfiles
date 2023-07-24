local util = require('util')

local M = {}

--- Make new client capabilities by merging the default capabilities with the
--- capabilities provided by the given client.
---
---@class lsp.ClientCapabilities LSP capabilities
---@param capabilities? (table|nil) Optional table of capabilities.
---@return lsp.ClientCapabilities (table) client capabilities.
function M.make_client_capabilities(capabilities)
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  return util.tbl_merge(
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    capabilities or {}
  )
end

--- Run code formatting for the current buffer synchronously.
---
---@param options (table|nil) Optional table which holds the following optional keys:
---  - force?: (boolean|nil) Force the formatter to run.
function M.format(options)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false and not (options and options.force) then
    return
  end

  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  local client_ids = util.tbl_reduce(clients, function(acc, client)
    if M.supports_format(client) then
      table.insert(acc, client.id)
    end
    return acc
  end, {})

  if #client_ids == 0 then
    return
  end

  vim.lsp.buf.format({
    async = false,
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  })
end

--- Run code actions for the current buffer synchronously.
---
---@param options (table|nil) Optional table which holds the following optional keys:
---  - force?: (boolean|nil) Force the code action to run.
---  - timeout_ms: (integer|nil) Timeout in milliseconds, or nil for default.
function M.code_action(options)
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.code_action == false and not (options and options.force) then
    return
  end

  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  local client_ids = util.tbl_reduce(clients, function(acc, client)
    if M.supports_action(client) then
      table.insert(acc, client.id)
    end
    return acc
  end, {})

  if #client_ids == 0 then
    return
  end

  local function filter(action)
    return action.isPreferred or action.kind == 'source.organizeImports'
  end

  local request_results = M.buf_request_code_action_sync(buf, options)
  for _, result in pairs(request_results or {}) do
    for _, action in pairs(result.result or {}) do
      if action.edit and filter(action) then
        vim.lsp.util.apply_workspace_edit(action.edit, vim.lsp.util._get_offset_encoding())
        -- else
        --   vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

--- Request code actions for the current buffer. This is a synchronous request
--- that will block for the given timeout, or until all clients respond.
---
---@param bufnr (integer) Buffer handle, or 0 for current.
---@param options? (table|nil) Optional table which holds the following optional keys:
---  - timeout_ms: (integer|nil) Timeout in milliseconds, or nil for default.
---@return table<integer, {err: lsp.ResponseError, result: any}>|nil (table) result Map of client_id:request_result.
---
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_codeAction
---@see vim.lsp.protocol.constants.CodeActionTriggerKind
function M.buf_request_code_action_sync(bufnr, options)
  local timeout_ms = options and options.timeout_ms
  local params = vim.lsp.util.make_range_params()

  -- set the context to include the current diagnostics. Without the diagnostics
  -- some client will not return code actions, or worse, will terminate
  -- unexpectedly.
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr),
  }

  -- make a synchronous request for available code actions, but do not apply
  -- them. This is to allow for the resuls to be filtered before applying.
  return vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, timeout_ms or 3000)
end

--- Determines if the client supports formatting.
---
---@param client (lsp.Client) LSP client.
---@return boolean supported `true` if the client supports formatting, otherwise `false`.
function M.supports_format(client)
  local capabilities = client.config and client.config.capabilities
  if capabilities and capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method('textDocument/formatting') or client.supports_method('textDocument/rangeFormatting')
end

--- Determines if the client supports the given action.
---
---@param client (lsp.Client) LSP client.
---@return boolean supported `true` if the client supports the action, otherwise `false`.
function M.supports_action(client)
  return client.supports_method('textDocument/codeAction')
end

--- Create an autocommand that runs before writing a buffer to disk.
---
---@param group (string|integer) autocommand group name or id to match against.
---@param callback fun() (function)
--- The callback to invoke when the autocommand is triggered. It is here that
--- we have the opportunity to run a code actions or format the buffer.
local function create_pre_write_command(group, callback)
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    callback = callback,
  })
end

--- Enable formatting on write for the current buffer.
function M.enable_formatting()
  create_pre_write_command(
    vim.api.nvim_create_augroup('LspFormat', {}),
    M.format
  )
end

--- Enable code actions on write for the current buffer.
---
---@param options? (table|nil) Optional table which holds the following optional keys:
---  - timeout_ms: (integer|nil) Timeout in milliseconds, or nil for default.
function M.enable_actions(options)
  create_pre_write_command(
    vim.api.nvim_create_augroup('LspCodeAction', {}),
    util.wrap(M.code_action, options)
  )
end

return M
