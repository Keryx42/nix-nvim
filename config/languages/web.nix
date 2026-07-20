{ pkgs, ... }:
{
  # Web languages: TypeScript, JavaScript, Vue, JSX/TSX
  # Includes TreeSitter grammars, LSP servers (vtsls, vue_ls, eslint), and prettier formatting

  # Note: TreeSitter grammars are configured centrally in config/treesitter.nix

  # LSP servers and settings
  plugins.lsp.servers = {
    # vtsls — handles <script>/<script setup> and all TS/JS features in .vue files
    vtsls = {
      enable = true;
      extraOptions = {
        root_dir = {
          __raw = ''
            function(bufnr, on_dir)
              local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
              root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                or vim.list_extend(root_markers, { ".git" })
              local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
              local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
              local project_root = vim.fs.root(bufnr, root_markers)
              if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then return end
              if deno_root and (not project_root or #deno_root >= #project_root) then return end
              if not project_root then return end
              on_dir(project_root)
            end
          '';
        };
      };
      filetypes = [
        "typescript"
        "javascript"
        "javascriptreact"
        "typescriptreact"
        "vue"
      ];
      settings = {
        complete_function_calls = true;

        vtsls = {
          enableMoveToFileCodeAction = true;
          autoUseWorkspaceTsdk = true;
          experimental = {
            maxInlayHintLength = 30;
            completion.enableServerSideFuzzyMatch = true;
          };
          tsserver = {
            globalPlugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                languages = [ "vue" ];
                configNamespace = "typescript";
                enableForWorkspaceTypeScriptVersions = true;
              }
            ];
            # Suppress TS6133 ("declared but never used") for Vue template refs
            # Template refs are declared in <script> but used in <template>
            # The @vue/typescript-plugin should detect this, but in older versions
            # there was a regression (v3.1.6+). This suppression is a safety measure
            # for better Vue 3 support with script setup and template refs.
            # See: https://github.com/vuejs/language-tools/issues/5815
            diagnosticsIgnored = [ 6133 ];
          };
        };

        typescript = {
          updateImportsOnFileMove.enabled = "always";
          suggest.completeFunctionCalls = true;
          inlayHints = {
            enumMemberValues.enabled = true;
            functionLikeReturnTypes.enabled = true;
            parameterNames.enabled = "literals";
            parameterTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            variableTypes.enabled = false;
          };
        };

        # Mirror typescript settings so JS files get identical behaviour
        javascript = {
          updateImportsOnFileMove.enabled = "always";
          suggest.completeFunctionCalls = true;
          inlayHints = {
            enumMemberValues.enabled = true;
            functionLikeReturnTypes.enabled = true;
            parameterNames.enabled = "literals";
            parameterTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            variableTypes.enabled = false;
          };
        };
      };
    };

    # Vue language server — handles <template> and <style> sections (hybrid mode)
    vue_ls = {
      enable = true;
      tslsIntegration = true;
    };

    # eslint LSP for diagnostics across JS/TS/Vue/JSON
    eslint = {
      enable = true;
      extraOptions = {
        root_dir = {
          __raw = ''
            function(filename)
              local config_file = vim.fs.find(
                {
                  "eslint.config.js",
                  "eslint.config.mjs",
                  "eslint.config.cjs",
                  ".eslintrc.js",
                  ".eslintrc.cjs",
                  ".eslintrc.yaml",
                  ".eslintrc.yml",
                  ".eslintrc.json",
                  ".eslintrc",
                },
                { upward = true, path = vim.fs.dirname(filename) }
              )[1]
              if not config_file then return nil end
              return vim.fs.dirname(config_file)
            end
          '';
        };
      };
      filetypes = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
        "vue"
        "json"
      ];
      settings = {
        # In ESLint 9 flat config, "auto" walks up to find eslint.config.js
        # rather than the nearest package.json, ensuring cwd = project root.
        # Fixes ENOENT on .gitignore in monorepos with per-module package.json.
        workingDirectory = { mode = "auto"; };
      };
    };
  };

  # Formatters: Prettier for all web filetypes
  plugins.conform-nvim.settings.formatters_by_ft = {
    javascript = [ "prettier" ];
    javascriptreact = [ "prettier" ];
    typescript = [ "prettier" ];
    typescriptreact = [ "prettier" ];
    vue = [ "prettier" ];
  };
}
