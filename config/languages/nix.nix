{ ... }:
{
  # Nix language support
  # Includes LSP (nixd) and formatter (nixfmt)
  # Note: TreeSitter grammar is configured centrally in config/treesitter.nix

  # LSP server: nixd for .nix and flake files
  plugins.lsp.servers.nixd = {
    enable = true;
  };

  # Formatter: nixfmt
  plugins.conform-nvim.settings.formatters_by_ft = {
    nix = [ "nixfmt" ];
  };
}
