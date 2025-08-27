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
    -- NOT EQUAL TO
    s({trig = "([^%a])n=", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\neq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- LESS THAN OR EQUAL TO
    s({trig = "([^%a])leq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\leq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- LESS THAN OR EQUAL TO
    s({trig = "([^%a])<=", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\leq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- GREATER THAN OR EQUAL TO
    s({trig = "([^%a])geq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\geq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- GREATER THAN OR EQUAL TO
    s({trig = "([^%a])>=", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\geq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),

    -- APPROXIMATION
    s({trig = "([^%a])apx", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\approx",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- EQUIVALENT
    s({trig = "([^%a])eq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\equiv ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NOT EQUIVALENT
    s({trig = "([^%a])neq ", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\not\\equiv ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MULTIPLICATION DOT
    s({trig = "([^%a])cdo", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cdot ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MULTIPLICATION SYMBOL
    s({trig = "([^%a])tms", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\times ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DIVISION SYMBOL
    s({trig = "([^%a])div", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\div ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DIVIDE
    s({trig = "([^%a])md", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mid ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NOT DIVIDE
    s({trig = "([^%a])nmd", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\nmid ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),

    -- FULLY DIVIDE
    s({trig = "([^%a])fdi", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mid \\! \\mid ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- PERPENDICULAR
    s({trig = "([^%a])prp", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\perp ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- PARALLEL
    s({trig = "([^%a])prl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\parallel ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SIMILAR
    s({trig = "([^%a])sim", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\sim ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- CONGRUENT
    s({trig = "([^%a])cog", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cong ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- IN / ELEMENT
    s({trig = "([^%a])in", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\in ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NOT IN / NOT ELEMENT
    s({trig = "([^%a])nin", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\notin ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- INTERSECTION
    s({trig = "([^%a])cap", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cap ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- UNION
    s({trig = "([^%a])cup", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cup ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SUBSET
    s({trig = "([^%a])suq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\subseteq ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- PROPER SUBSET
    s({trig = "([^%a])nsuq", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\subset ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
}
