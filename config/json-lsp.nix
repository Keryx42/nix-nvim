{ pkgs, ... }:
{
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
}
