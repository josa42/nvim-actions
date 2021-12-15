local eq = assert.are.same

local t = require('jg.actions.builtin.sort').__test__

describe('sort_lines()', function()
  local cases = {
    {
      lines = {
        'zz:',
        '  - one',
        'aa: 1',
      },
      sorted = table.concat({
        '  - one',
        'aa: 1',
        'zz:',
      }, '\n'),
      reversed = table.concat({
        'zz:',
        'aa: 1',
        '  - one',
      }, '\n'),
      sorted_grouped = table.concat({
        'aa: 1',
        'zz:',
        '  - one',
      }, '\n'),
    },
  }

  for _, c in ipairs(cases) do
    it('should sort lines', function()
      eq(c.sorted, t.sort_lines(c.lines))
    end)

    it('should sort lined grouped by indent', function()
      eq(c.sorted_grouped, t.sort_lines(c.lines, { group_by_indent = true }))
    end)

    it('should reverse', function()
      eq(c.reversed, t.sort_lines(c.lines, { reverse = true }))
    end)
  end
end)

describe('sort_line()', function()
  local items = { 'zz', 'aa', '  aa', '00' }
  local sorted = { '  aa', '00', 'aa', 'zz' }
  local reversed = { 'zz', 'aa', '00', '  aa' }
  local separators = { ',', ' , ', ';', ' ; ', ':', ' : ', '|', ' | ' }

  for _, sep in ipairs(separators) do
    describe('with items separated by "' .. sep .. '"', function()
      local line = table.concat(items, sep)

      it('should be sorted', function()
        eq(table.concat(sorted, sep), t.sort_line(line))
      end)

      it('should be reversed', function()
        eq(table.concat(reversed, sep), t.sort_line(line, { reverse = true }))
      end)
    end)
  end
end)
