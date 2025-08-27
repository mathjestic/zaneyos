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
    -- SIN (sin pangkat susah)
    s({trig = "([^%\\])sin", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\sin(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ARCSIN
    s({trig = "([^%\\])asin", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\arcsin(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- COS
    s({trig = "([^%\\])cos", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cos(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ARCCOS
    s({trig = "([^%\\])acos", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\arccos(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- TAN
    s({trig = "([^%\\])tan", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\tan(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- ARCTAN
    s({trig = "([^%\\])atan", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\arctan(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- CSC
    s({trig = "([^%\\])csc", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\csc(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SEC
    s({trig = "([^%\\])sec", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\sec(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- COT
    s({trig = "([^%\\])cot", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\cot(<>)",
            {
                f( function(_, snip) return snip.captures[1] end ),
                i(1),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
}
