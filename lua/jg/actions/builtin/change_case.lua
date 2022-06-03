local M = {}
-- local l = {}

function M.to_snake(str)
  -- from camelCase or ClassCase
  str = vim.fn.substitute(str, '\\v(\\l)(\\u)', '\\1_\\2', 'g')

  -- from dash-case or space case
  str = vim.fn.substitute(str, '[\\- ]', '_', 'g')

  str = string.lower(str)

  return str
end

function M.to_camel(str)
  -- from UPPER_CASE
  if string.upper(str) == str then
    str = string.lower(str)
  end

  -- from snake_case, dash-case or space case
  str = vim.fn.substitute(str, '\\v(.)[\\-_ ](.)', '\\l\\1\\u\\2', 'g')

  -- from ClassCase
  str = vim.fn.substitute(str, '\\v^.', '\\l&', '')

  return str
end

function M.to_dash(str)
  str = M.to_snake(str)
  str = vim.fn.substitute(str, '_', '-', 'g')

  return str
end

function M.to_class(str)
  str = M.to_camel(str)
  str = vim.fn.substitute(str, '\\v^.', '\\u&', '')

  return str
end

function M.to_title(str)
  str = M.to_space(str)
  str = vim.fn.substitute(str, '\\v(^| ).', '\\U&', 'g')

  return str
end

function M.to_upper(str)
  str = M.to_snake(str)
  str = string.upper(str)

  return str
end

function M.to_space(str)
  str = M.to_snake(str)
  str = vim.fn.substitute(str, '_', ' ', 'g')

  return str
end

--------------------------------------------------------------------------------
-- utils

-- function l.split(str)
--   return string.split(str, '_')
-- end

return M
