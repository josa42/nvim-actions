local M = {}

local actions = {}
local actions_idx = 0

function M.set(fn)
  actions_idx = actions_idx + 1
  local name = 'action_' .. actions_idx
  actions[name] = fn

  return name
end

function M.get(name)
  return actions[name]
end

return M
