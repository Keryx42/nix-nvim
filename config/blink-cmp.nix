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
      # Keymap: Use enter to accept, tab to navigate
      keymap = {
        preset = "enter";
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

  # Custom Lua: Auto-organize imports after accepting a completion
  extraConfigLua = ''
    -- Function to organize imports via LSP
    local function organize_imports()
      -- Use defer_fn to give time for the text to be inserted and LSP to process it
      vim.defer_fn(function()
        -- Call the built-in LSP code action with organizeImports filter
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        
        vim.lsp.buf_request(0, "codeAction", params, function(err, result, ctx)
          if err then
            return
          end
          
          if not result or vim.tbl_isempty(result) then
            return
          end
          
          -- Execute the first organizeImports action
          for _, action in ipairs(result) do
            if action.kind == "source.organizeImports" then
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
              end
              return
            end
          end
        end)
      end, 150)
    end
    
    -- Hook into blink.cmp's accept function
    local blink_cmp = require('blink.cmp')
    
    -- Store the original accept for later use
    if blink_cmp.accept then
      local original_accept = blink_cmp.accept
      
      function blink_cmp.accept(...)
        local result = original_accept(...)
        -- Schedule import organization after accepting
        organize_imports()
        return result
      end
    end
  '';
}

