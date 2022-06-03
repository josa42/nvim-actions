local eq = assert.are.same

local change_case = require('jg.actions.builtin.change_case')

local strs = {
  snake_case = 'snake_case_string',
  camel_case = 'camelCaseString',
  dash_case = 'dash-case-string',
  class_case = 'ClassCaseString',
  title_case = 'Title Case String',
  upper_case = 'UPPER_CASE_STRING',
  space_case = 'space case string',
  dot_case = 'dot.case.string',
}

local tests = {
  {
    fn_name = 'to_snake',
    expect = {
      snake_case = 'snake_case_string',
      camel_case = 'camel_case_string',
      dash_case = 'dash_case_string',
      class_case = 'class_case_string',
      title_case = 'title_case_string',
      upper_case = 'upper_case_string',
      space_case = 'space_case_string',
      dot_case = 'dot_case_string',
    },
  },
  {
    fn_name = 'to_camel',
    expect = {
      snake_case = 'snakeCaseString',
      camel_case = 'camelCaseString',
      dash_case = 'dashCaseString',
      class_case = 'classCaseString',
      title_case = 'titleCaseString',
      upper_case = 'upperCaseString',
      space_case = 'spaceCaseString',
      dot_case = 'dotCaseString',
    },
  },
  {
    fn_name = 'to_dash',
    expect = {
      snake_case = 'snake-case-string',
      camel_case = 'camel-case-string',
      dash_case = 'dash-case-string',
      class_case = 'class-case-string',
      title_case = 'title-case-string',
      upper_case = 'upper-case-string',
      space_case = 'space-case-string',
      dot_case = 'dot-case-string',
    },
  },
  {
    fn_name = 'to_class',
    expect = {
      snake_case = 'SnakeCaseString',
      camel_case = 'CamelCaseString',
      dash_case = 'DashCaseString',
      class_case = 'ClassCaseString',
      title_case = 'TitleCaseString',
      upper_case = 'UpperCaseString',
      space_case = 'SpaceCaseString',
      dot_case = 'DotCaseString',
    },
  },
  {
    fn_name = 'to_title',
    expect = {
      snake_case = 'Snake Case String',
      camel_case = 'Camel Case String',
      dash_case = 'Dash Case String',
      class_case = 'Class Case String',
      title_case = 'Title Case String',
      upper_case = 'Upper Case String',
      space_case = 'Space Case String',
      dot_case = 'Dot Case String',
    },
  },
  {
    fn_name = 'to_upper',
    expect = {
      snake_case = 'SNAKE_CASE_STRING',
      camel_case = 'CAMEL_CASE_STRING',
      dash_case = 'DASH_CASE_STRING',
      class_case = 'CLASS_CASE_STRING',
      title_case = 'TITLE_CASE_STRING',
      upper_case = 'UPPER_CASE_STRING',
      space_case = 'SPACE_CASE_STRING',
      dot_case = 'DOT_CASE_STRING',
    },
  },
  {
    fn_name = 'to_space',
    expect = {
      snake_case = 'snake case string',
      camel_case = 'camel case string',
      dash_case = 'dash case string',
      class_case = 'class case string',
      title_case = 'title case string',
      upper_case = 'upper case string',
      space_case = 'space case string',
      dot_case = 'dot case string',
    },
  },
  {
    fn_name = 'to_dot',
    expect = {
      snake_case = 'snake.case.string',
      camel_case = 'camel.case.string',
      dash_case = 'dash.case.string',
      class_case = 'class.case.string',
      title_case = 'title.case.string',
      upper_case = 'upper.case.string',
      space_case = 'space.case.string',
      dot_case = 'dot.case.string',
    },
  },
}

for _, t in ipairs(tests) do
  describe(t.fn_name .. '()', function()
    local fn = change_case[t.fn_name]

    for key, expect_str in pairs(t.expect) do
      it('should change case from "' .. strs[key] .. '" to "' .. expect_str .. '"', function()
        eq(expect_str, fn(strs[key]))
      end)
    end
  end)
end
