local handlers = require('jg.actions.handlers')

local M = {}
local l = {}

-- Options:
-- TODO: natural sort
-- TODO: reverse sort

function M.setup(key, opts)
  handlers.map(key, function(str)
    local lines = vim.fn.split(str, '\n')

    if #lines == 1 then
      return l.sort_line(lines[1], opts)
    end

    return l.sort_lines(lines, opts)
  end)
end

function l.sort_lines(lines, opts)
  -- TODO sort nested yaml or similar, based on indent
  -- TODO handle block visual block selections

  local prefix
  for _, line in ipairs(lines) do
    local pre = vim.fn.split(line, '\\v\\i+')[1]
    if prefix == nil or #pre < #prefix then
      prefix = pre
    end
  end

  local sortables = lines

  if opts ~= nil and opts.group_by_indent == true then
    sortables = {}
    for _, line in ipairs(lines) do
      local pre = vim.fn.split(line, '\\v\\i+')[1]
      if #pre > #prefix and #sortables > 0 then
        sortables[#sortables] = sortables[#sortables] .. '\n' .. line
      else
        table.insert(sortables, line)
      end
    end
  end

  table.sort(sortables, function(a, b)
    return a < b
  end)

  if opts and opts.reverse then
    sortables = l.reverse(sortables)
  end

  return table.concat(sortables, '\n')
end

-- extracted from https://github.com/christoomey/vim-sort-motion/blob/master/autoload/sort_motion.vim
function l.sort_line(str, opts)
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
  local sorted = vim.fn.sort(vim.fn.split(sortables, '\\V' .. vim.fn.escape(delimiter, '\\')))

  if opts and opts.reverse then
    sorted = l.reverse(sorted)
  end

  return prefix .. vim.fn.join(sorted, delimiter) .. suffix
end

function l.reverse(tbl)
  local reversed = {}
  for idx, value in ipairs(tbl) do
    reversed[#tbl + 1 - idx] = value
  end

  return reversed
end

return M
