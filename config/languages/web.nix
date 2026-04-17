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
              location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
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

    # Vue language server — handles <template> and <style> sections (hybrid mode)
    vue_ls = {
      enable = true;
      tslsIntegration = true;
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

  # Formatters: Prettier for all web filetypes
  plugins.conform-nvim.settings.formatters_by_ft = {
    javascript = [ "prettier" ];
    javascriptreact = [ "prettier" ];
    typescript = [ "prettier" ];
    typescriptreact = [ "prettier" ];
    vue = [ "prettier" ];
  };
}
