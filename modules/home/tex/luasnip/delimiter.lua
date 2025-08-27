-- From any snippet file, source `get_visual` from global helper functions file
-- local helpers = require('luasnip-helper-funcs')
-- local get_visual = helpers.get_visual

-- Be sure to explicitly define these LuaSnip node abbreviations!
local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node

local function get_visual(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

-- Some LaTeX-specific conditional expansion functions (requires VimTeX)
local mytex = {}
mytex.in_mathzone = function()  -- math context detection
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
mytex.in_text = function()
  return not mytex.in_mathzone()
end
mytex.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
mytex.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
mytex.in_equation = function()  -- equation environment detection
    return mytex.in_env('equation')
end
mytex.in_itemize = function()  -- itemize environment detection
    return mytex.in_env('itemize')
end
mytex.in_tikz = function()  -- TikZ picture environment detection
    return mytex.in_env('tikzpicture')
end
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
    -- INLINE MATH
    s({trig = "([^%a])mk", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\( <> \\)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        )
    ),
    -- INLINE MATH ON LINE BEGIN
    s({trig = "mk", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\( <> \\)",
            {
                d(1, get_visual),
            }
        ),
        {condition = line_begin}
    ),
    -- DISPLAY MATH
    s({trig = "dm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            [[
            \[
              <>
            \]
            ]],
            {
                d(1, get_visual),
            }
        ),
        {condition = line_begin}
    ),
    -- -- PARENTHESES
    s({trig = "%(", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "(<>)",
            {
                d(1, get_visual),
            }
        )
    ),
    -- LEFT/RIGHT PARENTHESES*
    s({trig = "([^%a])lpp", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\paren{ <> }",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- -- SQUARE BRACES
    s({trig = "%[", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "[<>]",
            {
                d(1, get_visual),
            }
        )
    ),
    -- LEFT/RIGHT SQUARE BRACES*
    s({trig = "([^%a])lbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\bkt{ <> }",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- -- CURLY BRACES
    s({trig = "%{", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- LEFT/RIGHT CURLY BRACES*
    s({trig = "([^%a])lss", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\set{ <> }",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ABSOLUTE VALUE*
    s({trig = "([^%a])avv", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\abs{ <> }",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- FLOOR*
    s({trig = "flr", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\floor{ <> }",
            {
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- CEILING*
    s({trig = "ceil", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\ceil{ <> }",
            {
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NORM*
    s({trig = "([^%a])nrm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\norm{ <> }",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ANSWER BOX
    s({trig = "ansbox", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\answerbox{ <> }",
            {
                d(1, get_visual),
            }
        )
    ),
    -- LABEL EQUATION
    s({trig = "lbleq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\labeleq{eq:<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- LABEL CLAIM
    s({trig = "lblcl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\label{cl:<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- CODE CITE
    s({trig = "cci", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\codecite{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- -- LATEX QUOTATION MARK
    -- s({trig = "``", snippetType="autosnippet"},
    --     fmta(
    --         "``<>''",
    --         {
    --             d(1, get_visual),
    --         }
    --     )
    -- ),
}

