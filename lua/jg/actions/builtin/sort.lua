local handlers = require('jg.actions.handlers')

local M = {}
local l = {}

-- Options:
-- TODO: natural sort
-- TODO: reverse sort

function M.setup(key)
  handlers.map(key, function(str)
    local lines = vim.fn.split(str, '\n')

    if #lines == 1 then
      return l.sort_line(lines[1])
    end

    return l.sort_lines(lines)
  end)
end

function l.sort_lines(lines)
  -- TODO sort nested yaml or similar, based on indent
  -- TODO handle block visual block selections

  table.sort(lines, function(a, b)
    return a < b
  end)

  return table.concat(lines, '\n')
end

-- extracted from https://github.com/christoomey/vim-sort-motion/blob/master/autoload/sort_motion.vim
function l.sort_line(str)
  local startpos = vim.fn.match(str, '\\v\\i')
  local parts = vim.fn.split(str, '\\v\\i+')

  -- TODO: allow sorting xml attributes: <div style="" class="" id="foo">

  local prefix = ''
  local delimiter = parts[1]
  local suffix = ''
  if startpos > 0 then
    delimiter = parts[2]

    if parts[1] ~= delimiter then
      prefix = parts[1]
    end

    if parts[#parts] ~= delimiter then
      suffix = parts[#parts]
    end
  end

  local sortstart = vim.fn.strlen(prefix)
  local sortend = vim.fn.strlen(str) - sortstart - vim.fn.strlen(suffix)
  local sortables = vim.fn.strpart(str, sortstart, sortend)
  local sorted = vim.fn.join(vim.fn.sort(vim.fn.split(sortables, '\\V' .. vim.fn.escape(delimiter, '\\'))), delimiter)

  return prefix .. sorted .. suffix
end

return M
