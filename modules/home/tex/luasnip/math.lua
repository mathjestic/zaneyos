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
    -- SQUARE
    s({trig = "([%w%)%]%}])sr", wordTrig=false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>^{2} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- CUBE
    s({trig = "([%w%)%]%}])cb", wordTrig=false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>^{3} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SUPERSCRIPT OR POWER
    s({trig = "([%w%)%]%}])''", wordTrig=false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>^{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- COMPLEMENT SUPERSCRIPT
    s({trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>^{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                t("\\complement")
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SUBSCRIPT AUTO 0-9
    s({trig = "([%a%)%]%}])([%d])", wordTrig=false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>_{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SUBSCRIPT
    s({trig = "([%w%)%]%}]);", wordTrig=false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>_{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SQUARE ROOT
    s({trig = "([^%\\])sq", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\sqrt{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NTH ROOT
    s({trig = "([^%\\])rt", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\sqrt[<>]{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- FRACTION AUTO a-z, A-Z, 0-9.
    s({trig = "([%w])/([%w])", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\frac{<>}{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                f( function(_, snip) return snip.captures[2] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- FRACTION
    s({trig = "([^%a])fr", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\frac{<>}{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DOTS
    s({trig = "([^%a])dot", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\dots ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SUM
    s({trig = "sm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\sum_{<>}^{<>} ",
            {
                i(1),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- PRODUCT
    s({trig = "pd", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\prod_{<>}^{<>} ",
            {
                i(1),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- BOX
    s({trig = "([^%a])box", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\boxed{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- IMPLIES
    s({trig = "=>", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\implies ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- IF AND ONLY IF (IFF)
    s({trig = "([^%a])iff", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\iff ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- TO
    s({trig = "([^%a])to", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\to ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MODULO
    s({trig = "([^%a])mod", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\pmod{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- FPB
    s({trig = "([^%a])fpb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathrm{FPB}(<>, <>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- KPK
    s({trig = "([^%a])kpk", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathrm{KPK}(<>, <>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ORDER
    s({trig = "([^%a])ord", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathrm{ord}_{<>} (<>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DEGREE OF POLYNOMIAL
    s({trig = "([^%a])deg", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\deg(<>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MIN
    s({trig = "([^%a])min", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\min_{<>}(<>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MAX
    s({trig = "([^%a])max", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\max_{<>}(<>) ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- BINOMIAL
    s({trig = "([^%\\])bnm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\binom{<>}{<>} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- UNDERBRACE
    s({trig = "unb", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\underbrace{<>}_{<>} ",
            {
                i(1),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- OVERBRACE
    s({trig = "ovb", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\overbrace{<>}^{<>} ",
            {
                i(1),
                i(2),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- UNDERLINE
    s({trig = "unl", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\underline{<>} ",
            {
                i(1),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- OVERLINE
    s({trig = "ovl", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "\\overline{<>} ",
            {
                i(1),
            }
        ),
        {condition = mytex.in_mathzone}
    ),

}

