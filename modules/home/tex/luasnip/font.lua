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
    -- ITALIC i.e. \textit
    s({trig = "([^%a])tii", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\textit{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        )
    ),
    -- BOLD i.e. \textbf
    s({trig = "tbb", snippetType="autosnippet"},
        fmta(
            "\\textbf{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- SLANTED i.e. \textsl
    s({trig = "tsl", snippetType="autosnippet"},
        fmta(
            "\\textsl{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- SMALL CAPS i.e. \textsc
    s({trig = "tsc", snippetType="autosnippet"},
        fmta(
            "\\textsc{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
    -- EMPHASIS i.e. \emph
    s({trig = "([^%a])emh", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
        fmta(
            "<>\\emph{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_text}
    ),
    -- SANS SERIF i.e. \textsf
    s({trig = "([^%a])tsf", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
        fmta(
            "<>\\textsf{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_text}
    ),
    -- TYPEWRITER i.e. \texttt
    s({trig = "([^%a])tt", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
        fmta(
            "<>\\texttt{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        {condition = mytex.in_text}
    ),
    -- MATH ROMAN i.e. \mathrm
    s({trig = "([^%a])mrm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathrm{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = mytex.in_mathzone }
    ),
    -- MATH CALIGRAPHY i.e. \mathcal
    s({trig = "([^%a])mcl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathcal{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = mytex.in_mathzone }
    ),
    -- MATH BOLDFACE i.e. \mathbf
    s({trig = "([^%a])mbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathbf{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = mytex.in_mathzone }
    ),
    -- MATH BLACKBOARD i.e. \mathbb
    s({trig = "([^%a])mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\mathbb{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = mytex.in_mathzone }
    ),
    -- REGULAR TEXT i.e. \text (in math environments)
    s({trig = "([^%a])txt", regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta(
            "<>\\text{<>}",
            {
                f( function(_, snip) return snip.captures[1] end ),
                d(1, get_visual),
            }
        ),
        { condition = mytex.in_mathzone }
    ),
}


