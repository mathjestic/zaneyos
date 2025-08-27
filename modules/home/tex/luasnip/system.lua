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
  -- DOCUMENTCLASS
  s({trig = "dcc", snippetType="autosnippet"},
    fmta(
      [=[
        \documentclass[<>]{<>}
      ]=],
      {
        i(1, "a4paper"),
        i(2, "article"),
      }
    ),
    { condition = line_begin }
  ),
  -- USEPACKAGE
  s({trig = "pack", snippetType="autosnippet"},
    fmta(
      [[
        \usepackage{<>}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- REQUIREPACKAGE
  s({trig = "rpac", snippetType="autosnippet"},
    fmta(
      [[
        \RequirePackage{<>}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- CHAPTER
  s({trig="h0", snippetType="autosnippet"},
    fmta(
      [[\chapter{<>}]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- SECTION
  s({trig="h1", snippetType="autosnippet"},
    fmta(
      [[\section{<>}]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- SUBSECTION
  s({trig="h2", snippetType="autosnippet"},
    fmta(
      [[\subsection{<>}]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- SUBSUBSECTION
  s({trig="h3", snippetType="autosnippet"},
    fmta(
      [[\subsubsection{<>}]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- %===================================
  s({trig="===", snippetType="autosnippet"},
    fmta(
      [[%=====================================================================================================%]],
      {}
    ),
    { condition = line_begin }
  ),
  -- %-----------------------------
  s({trig="---", snippetType="autosnippet"},
    fmta(
      [[%-------------------------------------------------------------------------------------------%]],
      {}
    ),
    { condition = line_begin }
  ),
  -- TEMPLATE HANDOUT
  s({ trig = "temphand", snippetType = "autosnippet" },
    fmta(
      [[
      \documentclass[12pt]{article}
      \usepackage[nolink,decor,nifle]{mathjestic}
      \title{<>}
      \subtitle{}
      \date{\today}

      \begin{document}

      \makecover{<>}
      \makethetitle

      \section{Materi}

      <>

      \section{Latihan}

      \printhints

      \printsolutions

      \end{document}
      ]],
      {
        i(1, "Handout Title"),
        rep(2),
        i(3, "here"),
      }
    ),
    { condition = line_begin }
  ),
}
