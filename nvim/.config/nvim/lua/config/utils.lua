local M = {}

function M.map(mode, lhs, rhs, opts, desc)
  -- Создаем новую таблицу, объединяя opts и desc
  local final_opts = vim.tbl_extend("force", opts or {}, { desc = desc })
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

return M
