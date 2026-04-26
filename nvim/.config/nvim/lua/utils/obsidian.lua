local M = {}

local function get_current_date()
  local file = vim.fn.expand("%:t:r") -- YYYY-MM-DD
  local y, m, d = file:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
  if not y then return nil end

  return os.time({
    year = tonumber(y),
    month = tonumber(m),
    day = tonumber(d),
  })
end

function M.go_relative(delta)
  local current = get_current_date()
  if not current then
    vim.notify("Not in a daily note", vim.log.levels.WARN)
    return
  end

  local target = current + (delta * 86400)
  local today = os.time({
    year = tonumber(os.date("%Y")),
    month = tonumber(os.date("%m")),
    day = tonumber(os.date("%d")),
  })

  -- THIS is the key trick:
  -- convert target date → offset relative to TODAY
  local offset = math.floor((target - today) / 86400)

  vim.cmd("ObsidianToday " .. offset)
end

return M
