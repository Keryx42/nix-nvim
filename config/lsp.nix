{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;

    servers = {
      # Nix language server for .nix / flake support
      nixd = {
        enable = true;
      };

      # Vue language server — handles <template> and <style> sections (hybrid mode)
      vue_ls = {
        enable = true;
        tslsIntegration = true;
      };

      # vtsls — handles <script>/<script setup> and all TS/JS features in .vue files
      vtsls = {
        enable = true;
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
            tsserver.globalPlugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
                languages = [ "vue" ];
                configNamespace = "typescript";
                enableForWorkspaceTypeScriptVersions = true;
              }
            ];
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

      # eslint LSP for diagnostics across JS/TS/Vue/JSON
      eslint = {
        enable = true;
        filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "json"
        ];
      };
    };
  };
}
