{ pkgs, ... }:
{
  # Marksman provides markdown language server with:
  # - Completions for markdown references and links
  # - Cross-file reference support for wiki-links
  # - Diagnostics for markdown issues
  # - Minimal configuration (works well with defaults)
  #
  # Markdown formatting is handled by Prettier via conform.nvim (config/conform.nix)

  plugins.lsp.servers.marksman = {
    enable = true;
    filetypes = [ "markdown" ];
  };
}
