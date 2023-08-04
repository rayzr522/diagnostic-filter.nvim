---@class DiagnosticFilters: table<string, string[]>
---@class Options: { diagnostic_filters: DiagnosticFilters }

local M = {
  ---@type Options
  opts = {
    diagnostic_filters = {}
  }
}

---@param bufn integer
function M.filter_diagnostics(bufn)
  ---@class Diag: Diagnostic
  ---@field namespace integer

  ---@type Diag[]
  local buf_diagnostics = vim.diagnostic.get(bufn)

  ---@type table<Diag, boolean>
  local diagnostics_to_omit = {}
  ---@type table<integer, boolean>
  local omit_namespaces = {}

  for _, d in ipairs(buf_diagnostics) do
    local patterns = M.opts.diagnostic_filters[d.source]
    if patterns and #patterns > 0 then
      local has_match
      for _, p in ipairs(patterns) do
        if has_match or string.match(d.message, p) then
          has_match = true
          diagnostics_to_omit[d] = true
          omit_namespaces[d.namespace] = true
        end
      end
    end
  end

  for n in pairs(omit_namespaces) do
    local filtered_diagnostics = vim.tbl_filter(
      function(v)
        return v.namespace == n and not diagnostics_to_omit[v]
      end,
      buf_diagnostics
    )
    vim.diagnostic.set(n, bufn, filtered_diagnostics)
  end
end

---@param opts Options
function M.setup(opts)
  M.opts = opts

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      M.filter_diagnostics(vim.api.nvim_get_current_buf())
    end,
  })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    M.filter_diagnostics(buf)
  end
end

return M
