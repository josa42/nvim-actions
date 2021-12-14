local M = {}

local actions = require('jg.actions.actions')

local cmd_for_motion = ':lua require("jg.actions").set_action_for_motion("%s")<cr>g@'
local cmd_for_selection = ':lua require("jg.actions").call_action("%s", vim.fn.visualmode())<cr>'
local cmd_for_line = ':lua require("jg.actions").call_action("%s", vim.v.count1)<cr>'

-- Adapted from unimpaired.vim by Tim Pope.
function M.call_action(name, actionType)
  local fn = actions.get(name)

  -- backup settings that we will change
  local sel_save = vim.o.selection
  local cb_save = vim.o.clipboard

  -- make selection and clipboard work the way we need
  vim.opt.selection = 'inclusive'
  vim.opt.clipboard:remove('unnnamed'):remove('unnamedplus')

  -- backup the unnamed register, which we will be yanking into
  local reg_save = vim.fn.getreg('@@')
  -- yank the relevant text, and also set the visual selection (which will be reused if the text
  -- needs to be replaced)

  if vim.fn.match(actionType, '\\v^\\d+$') == 0 then
    -- if type is a number, then select that many lines
    vim.cmd('silent normal! V' .. actionType .. '$y')
  elseif vim.fn.match(actionType, '\\v^.$') == 0 then
    -- if type is 'v', 'V', or '<C-V>' (i.e. 0x16) then reselect the visual region
    vim.cmd('silent normal! `<' .. actionType .. '`>y')
  elseif actionType == 'line' then
    -- line-based text motion
    vim.cmd("silent normal! '[V']y")
  elseif actionType == 'block' then
    -- block-based text motion
    vim.cmd('silent normal! `[\\<C-V>`]y')
  else
    -- char-based text motion
    vim.cmd('silent normal! `[v`]y')
  end

  -- call the user-defined function, passing it the contents of the unnamed register
  local repl = fn(vim.fn.getreg('@@'))

  -- if the function returned a value, then replace the text
  if type(repl) == 'string' then
    -- put the replacement text into the unnamed register, and also set it to be a
    -- characterwise, linewise, or blockwise selection, based upon the selection type of the
    -- yank we did above
    vim.fn.setreg('@', repl, vim.fn.getregtype('@'))
    -- relect the visual region and paste
    vim.cmd('normal! gvp')
  end

  -- restore saved settings and register value
  vim.fn.setreg('@@', reg_save)
  vim.o.selection = sel_save
  vim.o.clipboard = cb_save
end
--
function M.set_action_for_motion(name)
  _G.__operatorfunc = function(type)
    return M.call_action(name, type)
  end

  vim.go.operatorfunc = 'v:lua.__operatorfunc'
end

function M.map(key1, fn)
  local name = actions.set(fn)
  local key2 = key1 .. key1:sub(#key1, #key1)

  vim.api.nvim_set_keymap('n', key1, cmd_for_motion:format(name), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('x', key1, cmd_for_selection:format(name), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', key2, cmd_for_line:format(name), { noremap = true, silent = true })
end

function M.setup() end

return M
