{ ... }:
{
  # JSON language support
  # Includes jsonls LSP with schema validation and prettier formatting
  # Note: TreeSitter grammar is configured centrally in config/treesitter.nix

  # LSP server: jsonls with schema validation
  plugins.lsp.servers.jsonls = {
    enable = true;
    filetypes = [ "json" "jsonc" ];
    settings = {
      json = {
        # Enable schema validation
        schemas = [
          {
            fileMatch = [ "package.json" ];
            url = "https://json.schemastore.org/package.json";
          }
          {
            fileMatch = [ "tsconfig.json" ];
            url = "https://json.schemastore.org/tsconfig.json";
          }
          {
            fileMatch = [ "tailwind.config.json" ];
            url = "https://json.schemastore.org/tailwindcss-config.json";
          }
        ];
        validate.enable = true;
        maxDepth = 20;
      };
    };
  };

  # Formatter: prettier
  plugins.conform-nvim.settings.formatters_by_ft = {
    json = [ "prettier" ];
  };
}
