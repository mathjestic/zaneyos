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
	  s("trig", t("oke coba yang lain!@")),
-- alpha
    s({trig = ";a", snippetType="autosnippet"},
        fmta(
            "\\alpha",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- beta
    s({trig = ";b", snippetType="autosnippet"},
        fmta(
            "\\beta",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- gamma
    s({trig = ";g", snippetType="autosnippet"},
        fmta(
            "\\gamma",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- GAMMA
    s({trig = ";G", snippetType="autosnippet"},
        fmta(
            "\\Gamma",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- delta
    s({trig = ";d", snippetType="autosnippet"},
        fmta(
            "\\delta",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Delta
    s({trig = ";D", snippetType="autosnippet"},
        fmta(
            "\\Delta",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- epsilon (but I prefer \varepsilon)
    s({trig = ";e", snippetType="autosnippet"},
        fmta(
            "\\varepsilon",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- lambda
    s({trig = ";l", snippetType="autosnippet"},
        fmta(
            "\\lambda",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- mu
    s({trig = ";m", snippetType="autosnippet"},
        fmta(
            "\\mu",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- pi
    s({trig = "pi", snippetType="autosnippet"},
        fmta(
            "\\pi",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Pi
    s({trig = "Pi", snippetType="autosnippet"},
        fmta(
            "\\Pi",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- phi
    s({trig = ";p", snippetType="autosnippet"},
        fmta(
            "\\phi",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Phi
    s({trig = ";P", snippetType="autosnippet"},
        fmta(
            "\\Phi",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- sigma
    s({trig = ";s", snippetType="autosnippet"},
        fmta(
            "\\sigma",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Sigma
    s({trig = ";S", snippetType="autosnippet"},
        fmta(
            "\\Sigma",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- tau
    s({trig = ";t", snippetType="autosnippet"},
        fmta(
            "\\tau",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- theta
    s({trig = ";o", snippetType="autosnippet"},
        fmta(
            "\\theta",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Theta
    s({trig = ";O", snippetType="autosnippet"},
        fmta(
            "\\Theta",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- omega
    s({trig = ";w", snippetType="autosnippet"},
        fmta(
            "\\omega",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
-- Omega
    s({trig = ";W", snippetType="autosnippet"},
        fmta(
            "\\Omega",
            {}
        ),
        {condition = mytex.in_mathzone}
    ),
}

