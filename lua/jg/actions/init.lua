local M = {}

local sort = require('jg.actions.builtin.sort')

M.map = require('jg.actions.handlers').map

function M.setup()
  sort.setup('gs', { group_by_indent = true, reverse = false })
  sort.setup('gz', { group_by_indent = true, reverse = true })
end

return M
