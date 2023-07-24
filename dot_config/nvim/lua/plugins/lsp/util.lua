local M = {}

--- Create an autocmd that will call the given function when an LSP client
--- attaches to a buffer.
---
---@class lsp.Client LSP client
---@param on_attach fun(client:lsp.Client, bufrnr:string|integer) A function to call when a client attaches.
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

return M
