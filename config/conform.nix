{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      # Format on save (async, 500ms timeout)
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };

      # Map filetypes to formatters
      formatters_by_ft = {
        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        json = [ "prettier" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        vue = [ "prettier" ];
        markdown = [ "prettier" ];
        nix = [ "nixfmt" ];
      };

      formatters = {
        prettier = {
          condition = {
            __raw = ''
              function(self, ctx)
                return vim.fs.find(
                  {
                    ".prettierrc",
                    ".prettierrc.js",
                    ".prettierrc.cjs",
                    ".prettierrc.mjs",
                    ".prettierrc.json",
                    ".prettierrc.json5",
                    ".prettierrc.yaml",
                    ".prettierrc.yml",
                    "prettier.config.js",
                    "prettier.config.cjs",
                    "prettier.config.mjs",
                  },
                  { upward = true, path = ctx.dirname }
                )[1] ~= nil
              end
            '';
          };
        };
        nixfmt = { };
      };
    };
  };
}
