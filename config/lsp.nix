{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;

    servers = {
      # Vue language server (handles HTML/CSS sections of .vue files)
      vue_ls = {
        enable = true;
        tslsIntegration = true;
      };

      # vtsls handles TypeScript in .vue files via @vue/typescript-plugin
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
          vtsls = {
            tsserver = {
              globalPlugins = [
                {
                  name = "@vue/typescript-plugin";
                  location = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
                  languages = [ "vue" ];
                  configNamespace = "typescript";
                }
              ];
            };
          };
        };
      };

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
