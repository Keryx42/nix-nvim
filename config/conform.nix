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
        typescript = [ "prettier" ];
        json = [ "prettier" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        nix = [ "nixfmt" ];
      };

      # Formatter-specific options (optional)
      formatters = {
        prettier = {
          # Inherits prettier from flake.nix devShell
        };
        nixfmt = {
          # Inherits nixfmt from flake.nix devShell
        };
      };
    };
  };
}
