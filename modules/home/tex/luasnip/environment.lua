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
mytex.in_mathzone = function() -- math context detection
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
mytex.in_text = function()
    return not mytex.in_mathzone()
end
mytex.in_comment = function() -- comment detection
    return vim.fn['vimtex#syntax#in_comment']() == 1
end
mytex.in_env = function(name) -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
mytex.in_equation = function() -- equation environment detection
    return mytex.in_env('equation')
end
mytex.in_itemize = function() -- itemize environment detection
    return mytex.in_env('itemize')
end
mytex.in_tikz = function() -- TikZ picture environment detection
    return mytex.in_env('tikzpicture')
end
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  -- GENERIC ENVIRONMENT
  s({ trig = "bg", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{<>}
        <>
      \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- -- EQUATION
  -- s({ trig = "eq", snippetType = "autosnippet" },
  --   fmta(
  --     [[
  --     \begin{equation*}
  --       <>
  --     \end{equation*}
  --     ]],
  --     {
  --       i(1),
  --     }
  --   ),
  --   { condition = line_begin }
  -- ),
  -- EQUATION ALIGNED
  s({ trig = "eqal", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{equation*}
        \begin{aligned}
          <>
        \end{aligned}
      \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- -- SPLIT EQUATION
  -- s({ trig = "sq", snippetType = "autosnippet" },
  --   fmta(
  --     [[
  --     \begin{equation*}
  --       \begin{split}
  --         <>
  --       \end{split}
  --     \end{equation*}
  --     ]],
  --     {
  --       d(1, get_visual),
  --     }
  --   ),
  --   { condition = line_begin }
  -- ),
  -- CASES
  s({ trig = "case", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{cases}
        <>
      \end{cases}
      ]],
      {
        i(1),
      }
    ),
    { condition = mytex.in_mathzone }
  ),
  -- ALIGN
  s({ trig = "alig", snippetType = "autosnippet" },
    fmta(
      [[
      \begingroup
        \allowdisplaybreaks
        \changetoshortskip
        \begin{align*}
          <>
        \end{align*}
      \endgroup
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ITEMIZE (enter nya nggak auto \item, dan nggak auto align)
  s({ trig = "([^%a])item", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{itemize}
        \item <>
      \end{itemize}
      ]],
      {
        i(1),
      }
    )
  ),
  -- ENUMERATE
  s({ trig = "enum", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{enumerate}
        \item <>
      \end{enumerate}
      ]],
      {
        i(1),
      }
    )
  ),
  -- -- LSTLISTING FOR CODE
  -- s({ trig = "lst", snippetType = "autosnippet" },
  --   fmta(
  --     [[
  --     \begin{lstlisting}
  --       <>
  --     \end{lstlisting}
  --     ]],
  --     {
  --       d(1, get_visual),
  --     }
  --   )
  -- ),
  -- PROBLEM
  s({ trig = "qq", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{problem}
        \begin{statement}
          <>
        \end{statement}
      \end{problem}
      ]],
      {
        i(1, "statement"),
      }
    ),
    { condition = line_begin }
  ),
  -- HINT
  s({ trig = "hnt", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{hint}
        <>
      \end{hint}
      ]],
      {
        i(1, "hint"),
      }
    ),
    { condition = line_begin }
  ),
  -- SOLUTION
  s({ trig = "soln", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{solution}
        <>
      \end{solution}
      ]],
      {
        i(1, "solution"),
      }
    ),
    { condition = line_begin }
  ),
  -- OPEN PROBLEM SET
  s({ trig = "pset", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{problemset}{<>}
        <>
      \end{problemset}
      ]],
      {
        i(1, "pset name"),
        i(2, "here"),
      }
    ),
    { condition = line_begin }
  ),
  -- INCLUDE GRAPHICS
  s({ trig = "incgr", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{center}
        \includegraphics{<>}
      \end{center}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
}
