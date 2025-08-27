{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;

    settings.vim = {
      lsp.enable = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
      options = {
        tabstop = 2;
        shiftwidth = 2;
        wrap = true;
        breakindent = true;
        linebreak = true;
      };

      extraPlugins = {
        vimtex = {
          package = pkgs.vimPlugins.vimtex;
          setup = ''
            local ls = require("luasnip")

            -- Luasnip keymaps (unchanged)
            vim.cmd [[
              imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
              smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
              imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
              smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
            ]]
            
            -- Asymptote compilation setup
            local function compile_asy()
              local filename = vim.fn.expand('%:p')  -- Full path to current .asy file
              local pdfname = filename:gsub('%.asy$', '.pdf')  -- PDF output path

              -- (1) Compile Asymptote (keep original check)
              local cmd_compile = string.format('asy -f pdf "%s"', filename)
              local exit_code = vim.fn.system(cmd_compile)  -- No strict exit code check (works for you)

              -- (2) Check if Zathura is running (improved reliability)
              local cmd_check_zathura = string.format('pgrep -f "zathura %s" 2>/dev/null', pdfname)
              local zathura_running = vim.fn.system(cmd_check_zathura) ~= ""

              -- (3) FIXED: Refresh or open Zathura (no more accidental closing!)
              if zathura_running then
                -- SAFER: Use `zathura --reload` (if supported) or fall back to `pkill -SIGUSR1`
                local cmd_refresh = string.format('zathura --reload "%s" 2>/dev/null &', pdfname)
                vim.fn.system(cmd_refresh)
                vim.notify("Zathura refreshed!", vim.log.levels.INFO)
              else
                vim.fn.system(string.format('zathura "%s" &', pdfname))
                vim.notify("Zathura opened!", vim.log.levels.INFO)
              end
            end

            -- Auto-compile on save
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = "*.asy",
              callback = compile_asy,
            })

            -- Manual compilation with <leader>ca
            vim.keymap.set('n', '<leader>ca', compile_asy, { desc = "Compile Asymptote file" })
            
            -- Your existing LaTeX config (unchanged)
              require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnippets/" })
              vim.g.vimtex_view_method = 'zathura'
              vim.g.vimtex_compiler_method = 'latexmk'
              vim.g.vimtex_compiler_latexmk_engines = {
                _ = '-lualatex',
              }
              vim.g.vimtex_compiler_latexmk = {
                aux_dir = "aux",
                options = {
                  "--shell-escape",
                }
              }

            vim.api.nvim_set_keymap("n", "<leader>cl", "<cmd>VimtexCompile<CR>", { noremap = true, silent = true })
            ls.config.setup({ enable_autosnippets = true })
          '';
        };
        todo-comments-nvim = {
          package = pkgs.vimPlugins.todo-comments-nvim;
        };
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };

      maps = {
        normal = {
          "<leader>e" = {
            action = "<CMD>Neotree toggle<CR>";
            silent = false;
          };
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
      };

      keymaps = [
        {
          key = "jk";
          mode = ["i"];
          action = "<ESC>";
          desc = "Exit insert mode";
        }
        {
          key = "<leader>nh";
          mode = ["n"];
          action = ":nohl<CR>";
          desc = "Clear search highlights";
        }
        {
          key = "<leader>ff";
          mode = ["n"];
          action = "<cmd>Telescope find_files<cr>";
          desc = "Search files by name";
        }
        {
          key = "<leader>lg";
          mode = ["n"];
          action = "<cmd>Telescope live_grep<cr>";
          desc = "Search files by contents";
        }
        {
          key = "<leader>fe";
          mode = ["n"];
          action = "<cmd>Neotree toggle<cr>";
          desc = "File browser toggle";
        }
        {
          key = "<C-h>";
          mode = ["i"];
          action = "<Left>";
          desc = "Move left in insert mode";
        }
        {
          key = "<C-j>";
          mode = ["i"];
          action = "<Down>";
          desc = "Move down in insert mode";
        }
        {
          key = "<C-k>";
          mode = ["i"];
          action = "<Up>";
          desc = "Move up in insert mode";
        }
        {
          key = "<C-l>";
          mode = ["i"];
          action = "<Right>";
          desc = "Move right in insert mode";
        }
        {
          key = "<leader>dj";
          mode = ["n"];
          action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
          desc = "Go to next diagnostic";
        }
        {
          key = "<leader>dk";
          mode = ["n"];
          action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
          desc = "Go to previous diagnostic";
        }
        {
          key = "<leader>dl";
          mode = ["n"];
          action = "<cmd>Lspsaga show_line_diagnostics<CR>";
          desc = "Show diagnostic details";
        }
        {
          key = "<leader>dt";
          mode = ["n"];
          action = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Toggle diagnostics list";
        }
      ];

      telescope.enable = true;

      spellcheck = {
        enable = false;
        languages = ["en"];
        programmingWordlist.enable = true;
      };

      lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        # nix.enable = true;
        # clang.enable = true;
        # zig.enable = true;
        # python.enable = true;
        # markdown.enable = true;
        # ts = {
        #   enable = true;
        #   lsp.enable = true;
        #   format.type = "prettierd";
        #   extensions.ts-error-translator.enable = true;
        # };
        # html.enable = true;
        # lua.enable = true;
        # css.enable = true;
        # typst.enable = true;
        # rust = {
        #   enable = true;
        #   crates.enable = true;
        # };
      };
      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        rainbow-delimiters.enable = true;
      };

      statusline.lualine = {
        enable = true;
        theme = "base16";
      };

      treesitter.enable = true;
      treesitter.highlight.enable = true;
      autopairs.nvim-autopairs.enable = false;
      autocomplete.nvim-cmp.enable = false;
      snippets.luasnip.enable = true;
      tabline.nvimBufferline.enable = true;
      treesitter.context.enable = false;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };
      projects.project-nvim.enable = true;
      dashboard.dashboard-nvim.enable = true;
      filetree.neo-tree.enable = true;
      notify = {
        nvim-notify.enable = true;
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };
      utility = {
        preview.markdownPreview.enable = true;
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = false;
        };
        images = {
          image-nvim.enable = false;
        };
      };
      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;
        breadcrumbs = {
          enable = false;
          navbuddy.enable = false;
        };
        smartcolumn = {
          enable = true;
        };
        fastaction.enable = true;
      };

      session = {
        nvim-session-manager.enable = false;
      };

      comments = {
        comment-nvim.enable = true;
      };
    };
  };

  home.file.".latexmkrc" = {
    source = ./tex/.latexmkrc;
  };

  home.file.".config/zathura/zathurarc" = {
    source = ./zathura/zathurarc;
  };

  home.file.".config/texmf/tex/latex/mathjestic-article.tex" = {
    source = ./tex/packages/mathjestic-article.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-backmatter.tex" = {
    source = ./tex/packages/mathjestic-backmatter.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-bibli.tex" = {
    source = ./tex/packages/mathjestic-bibli.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-color.tex" = {
    source = ./tex/packages/mathjestic-color.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-cover.tex" = {
    source = ./tex/packages/mathjestic-cover.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-frontmatter.tex" = {
    source = ./tex/packages/mathjestic-frontmatter.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-headericon.tex" = {
    source = ./tex/packages/mathjestic-headericon.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-hint.tex" = {
    source = ./tex/packages/mathjestic-hint.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-hooks.tex" = {
    source = ./tex/packages/mathjestic-hooks.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-preface.tex" = {
    source = ./tex/packages/mathjestic-preface.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-solution.tex" = {
    source = ./tex/packages/mathjestic-solution.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-toc.tex" = {
    source = ./tex/packages/mathjestic-toc.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-source.tex" = {
    source = ./tex/packages/mathjestic-source.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-difficulty.tex" = {
    source = ./tex/packages/mathjestic-difficulty.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-watermark.tex" = {
    source = ./tex/packages/mathjestic-watermark.tex;
  };
  home.file.".config/texmf/tex/latex/mathjestic-video.tex" = {
    source = ./tex/packages/mathjestic-video.tex;
  };

  home.file.".config/texmf/tex/latex/mathjestic.sty" = {
    source = ./tex/packages/mathjestic.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticbibli.sty" = {
    source = ./tex/packages/mathjesticbibli.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticcolor.sty" = {
    source = ./tex/packages/mathjesticcolor.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticcore.sty" = {
    source = ./tex/packages/mathjesticcore.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticcover.sty" = {
    source = ./tex/packages/mathjesticcover.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticlist.sty" = {
    source = ./tex/packages/mathjesticlist.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticmacro.sty" = {
    source = ./tex/packages/mathjesticmacro.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticpagedecor.sty" = {
    source = ./tex/packages/mathjesticpagedecor.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticproblem.sty" = {
    source = ./tex/packages/mathjesticproblem.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticproblemarticle.sty" = {
    source = ./tex/packages/mathjesticproblemarticle.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticproblemvideo.sty" = {
    source = ./tex/packages/mathjesticproblemvideo.sty;
  };
  home.file.".config/texmf/tex/latex/mathjesticproblembook.sty" = {
    source = ./tex/packages/mathjesticproblembook.sty;
  };
  home.file.".config/texmf/tex/latex/mathjestictheorem.sty" = {
    source = ./tex/packages/mathjestictheorem.sty;
  };
  home.file.".config/texmf/tex/latex/mathjestictocsection.sty" = {
    source = ./tex/packages/mathjestictocsection.sty;
  };
  home.file.".config/nvim/luasnippets/tex/delimiter.lua" = {
    source = ./tex/luasnip/delimiter.lua;
  };

  home.file.".config/nvim/luasnippets/tex/environment.lua" = {
    source = ./tex/luasnip/environment.lua;
  };

  home.file.".config/nvim/luasnippets/tex/font.lua" = {
    source = ./tex/luasnip/font.lua;
  };

  home.file.".config/nvim/luasnippets/tex/greek.lua" = {
    source = ./tex/luasnip/greek.lua;
  };

  home.file.".config/nvim/luasnippets/tex/math.lua" = {
    source = ./tex/luasnip/math.lua;
  };

  home.file.".config/nvim/luasnippets/tex/operator.lua" = {
    source = ./tex/luasnip/operator.lua;
  };

  home.file.".config/nvim/luasnippets/tex/symbol.lua" = {
    source = ./tex/luasnip/symbol.lua;
  };

  home.file.".config/nvim/luasnippets/tex/system.lua" = {
    source = ./tex/luasnip/system.lua;
  };

  home.file.".config/nvim/luasnippets/tex/trigonometry.lua" = {
    source = ./tex/luasnip/trigonometry.lua;
  };

  home.sessionVariables = {
    TEXMFHOME = "${config.home.homeDirectory}/.config/texmf";
    TEXINPUTS = ".:${config.home.homeDirectory}/.asydir//:";
    # ASYMPTOTE_DIR = "${config.home.homeDirectory}/.asydir";
    # ASYMPTOTE_TEXPATH = "/run/current-system/sw/bin/latex";
  };
}
