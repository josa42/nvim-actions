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

  local sortables = lines

  if opts ~= nil and opts.group_by_indent == true then
    sortables = l.group_by_indent(sortables)
  end

  local sorted = vim.fn.sort(sortables)

  if opts and opts.reverse then
    sorted = vim.fn.reverse(sorted)
  end

  return table.concat(sorted, '\n')
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

  local sort_start = vim.fn.strlen(prefix)
  local sort_end = vim.fn.strlen(str) - sort_start - vim.fn.strlen(suffix)
  local sortables = vim.fn.split(vim.fn.strpart(str, sort_start, sort_end), '\\V' .. vim.fn.escape(delimiter, '\\'))

  local sorted = vim.fn.sort(sortables)

  if opts and opts.reverse then
    sorted = vim.fn.reverse(sorted)
  end

  return prefix .. vim.fn.join(sorted, delimiter) .. suffix
end

function l.group_by_indent(sortables)
  local grouped = {}

  local prefix
  for _, line in ipairs(sortables) do
    local pre = vim.fn.split(line, '\\v\\i+')[1]
    if prefix == nil or #pre < #prefix then
      prefix = pre
    end
  end

  for _, line in ipairs(sortables) do
    local pre = vim.fn.split(line, '\\v\\i+')[1]
    if #pre > #prefix and #grouped > 0 then
      grouped[#grouped] = grouped[#grouped] .. '\n' .. line
    else
      table.insert(grouped, line)
    end
  end

  return grouped
end

return M
