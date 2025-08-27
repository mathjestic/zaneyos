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
    -- ANGLE
    s({trig = "([^%a])agl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\angle ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DIRECTED ANGLE
    s({trig = "([^%a])dag", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\measuredangle ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- DEGREE
    s({trig = "([^%a])dg", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>^{\\circ} ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- TRIANGLE
    s({trig = "([^%a])trg", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\triangle ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SQUARE SYMBOL
    s({trig = "([^%a])fgg", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\square ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- FORALL
    s({trig = "([^%a])forall", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\forall ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- THERE EXISTS
    s({trig = "([^%a])exist", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\exists ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- INFINITY
    s({trig = "([^%d])0o", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\infty ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- EMPTYSET
    s({trig = "([^%a])emptys", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\emptyset ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- PLUS MINUS
    s({trig = "([^%a])pm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\pm ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- MINUS PLUS
    s({trig = "([^%a])mp", wordTrig = false, regTrig = true, snippetType="autosnippet"},
        fmta(
            "<>\\mp ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            }
        ),
        {condition = mytex.in_mathzone}
    ),
    -- COMPLEX NUMBER
    s({trig = "CC", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathbb{C} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- REAL NUMBER
    s({trig = "RR", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathbb{R} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- RATIONAL NUMBER
    s({trig = "QQ", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathbb{Q} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- INTEGER
    s({trig = "ZZ", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathbb{Z} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- NATURAL NUMBER
    s({trig = "NN", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathbb{N} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SET L
    s({trig = "LL", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathcal{L} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SET H
    s({trig = "HH", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathcal{H} ",
            {} 
        ),
        {condition = mytex.in_mathzone}
    ),
    -- SET P
    s({trig = "PP", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "\\mathcal{P} ",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
    -- QED (not showing?!)
    s({trig = "([^%a])qed", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\qedhere ",
            {
                f( function(_, snip) return snip.captures[1] end ),
            } 
        ),
        {condition = mytex.in_mathzone}
    ),

}
