{
  # Autocompletion engine with LSP sources
  # blink.cmp is a modern, Rust-based completion engine that provides:
  # - Fast, responsive completions from LSP servers
  # - Auto-imports via LSP additionalTextEdits (transparent to user)
  # - Auto-brackets for function completions
  # - Built-in documentation preview
  #
  # Auto-import behavior:
  # When accepting a completion that requires imports (e.g., useRouter from vue-router),
  # the LSP server (vtsls, vue_ls, eslint) includes those imports in additionalTextEdits,
  # which blink.cmp applies automatically. No extra configuration needed.

  plugins.blink-cmp = {
    enable = true;

    # Auto-configure LSP completion capabilities (required for LSP integration)
    setupLspCapabilities = true;

    settings = {
      # Keymap configuration with <CR> as primary acceptance key
      keymap.preset = "super-tab";

      # Command-line mode keymap (ensure <CR> accepts completion)
      cmdline.keymap = {
        preset = "super-tab";
      };

      # Completion behavior
      completion = {
        # Accept completions and automatically insert brackets for functions
        accept.auto_brackets.enabled = true;

        # Documentation window (hover preview)
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };

        # Menu appearance and selection behavior
        menu = {
          draw = {
            # Use treesitter for syntax highlighting in completion menu
            treesitter = [ "lsp" ];
          };
          # Auto-select first item but don't auto-insert
          selection = {
            preselect = true;
            auto_insert = false;
          };
        };

        # Keyword range for fuzzy matching
        keyword.range = "prefix";

        # Ghost text (show completion as gray suggestion)
        ghost_text.enabled = false;
      };

      # Completion sources (providers)
      sources = {
        # Default providers list: LSP + buffer + path
        default = [ "lsp" "buffer" "path" ];

        # Provider configuration
        providers = {
          # LSP provider (primary source for intelligent completions + auto-imports)
          lsp = {
            name = "LSP";
            module = "blink.cmp.sources.lsp";
            # Don't fall back to buffer if LSP has results
            fallbacks = [ ];
            # Score offset (higher = prioritized)
            score_offset = 0;
            # Timeout for LSP requests
            timeout_ms = 500;
          };

          # Buffer provider (fallback for open file content)
          buffer = {
            name = "Buffer";
            module = "blink.cmp.sources.buffer";
            min_keyword_length = 3;
            # Lower priority than LSP
            score_offset = -7;
          };

          # Path provider (file/directory completion)
          path = {
            name = "Path";
            module = "blink.cmp.sources.path";
            score_offset = 0;
          };
        };

        # Command-line completion sources (disabled for now)
        cmdline = [ ];
      };

      # Appearance and styling
      appearance = {
        # Use nerd font variants for icons
        nerd_font_variant = "normal";
        # Use highlights compatible with nvim-cmp for consistency
        use_nvim_cmp_as_default = true;
        # Highlight groups for menu
        highlights = {
          default_menu_selected_bg = "BlinkCmpMenuSelection";
        };
      };

      # Signature help (function parameter hints)
      signature = {
        enabled = true;
        # Trigger signature help on opening parens
        window.border = "rounded";
      };

      # Snippet configuration (disabled - snippets not in scope)
      # If snippets are added later, configure here:
      # snippets = {
      #   preset = "default";
      #   expand = "luasnip";
      # };
    };
  };
}
