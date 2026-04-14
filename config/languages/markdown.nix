{ ... }:
{
  # Markdown language support
  # Includes marksman LSP and prettier formatting
  # Note: TreeSitter grammars are configured centrally in config/treesitter.nix

  # LSP server: marksman with cross-file reference support
  plugins.lsp.servers.marksman = {
    enable = true;
    filetypes = [ "markdown" ];
  };

  # Formatter: prettier
  plugins.conform-nvim.settings.formatters_by_ft = {
    markdown = [ "prettier" ];
  };
}
