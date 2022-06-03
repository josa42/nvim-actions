local M = {}

local sort = require('jg.actions.builtin.sort')
local change_case = require('jg.actions.builtin.change_case')

M.map = require('jg.actions.handlers').map

function M.setup()
  sort.setup('gs', { group_by_indent = true, reverse = false })
  sort.setup('gz', { group_by_indent = true, reverse = true })

  M.map('gkc', change_case.to_camel)
  M.map('gk_', change_case.to_snake)
  M.map('gku', change_case.to_upper)
  M.map('gkt', change_case.to_title)
  M.map('gks', change_case.to_sentence)
  M.map('gk<space>', change_case.to_space)
  M.map('gk-', change_case.to_dash)
  M.map('gk.', change_case.to_dot)

  -- M.map('gkk', change_case.cycle)
end

return M
