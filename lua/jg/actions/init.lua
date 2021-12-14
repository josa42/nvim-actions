local M = {}

local sort = require('jg.actions.builtin.sort')

M.map = require('jg.actions.handlers').map

function M.setup()
  sort.setup('gs')
end

return M
