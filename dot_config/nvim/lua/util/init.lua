local M = {}

--- Creates a shallow copy of a table.
---
---@generic T
---@param t table<any, T> Table
---@return table<any, T>
function M.tbl_copy(t)
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = v
  end
  return copy
end

--- Merges the arguments, returning a new table. Values will me merged in-place
--- in the first left-most table. If you want the result to be in a new table,
--- then simply pass an empty table as the first argument.
---
---@param t table A table to merge into.
---@param ... table A list of tables to merge into to `t`.
function M.tbl_merge(t, ...)
  local args = { ... }
  return vim.tbl_deep_extend('force', t, unpack(args))
end

--- Reduces a table to a single value.
---
---@generic T
---@generic U
---@param tbl table<any, T> Table
---@param func function(acc:U, val:T):U The reduce function
---@param init U Initial value
---@return U
function M.tbl_reduce(tbl, func, init)
  local acc = init
  for _, v in ipairs(tbl) do
    acc = func(acc, v)
  end
  return acc
end

--- Wraps a function, returning a new function that will call the original
--- function with the given arguments.
---
---@param func function(...:any) A function to wrap
---@param ... any A list of arguments to pass to `func`
---@return function
function M.wrap(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
end

return M
