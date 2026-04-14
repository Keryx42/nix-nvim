{ ... }:
{
  # Python language support
  # Includes LSP (pyright), formatter (black), and linting (ruff)
  # Note: TreeSitter grammar is configured centrally in config/treesitter.nix

  # LSP server: pyright for type checking and diagnostics
  plugins.lsp.servers.pyright = {
    enable = true;
    settings = {
      python.analysis = {
        # Standard type checking mode balances accuracy and performance
        typeCheckingMode = "standard";
        autoImportCompletions = true;
        autoSearchPaths = true;
      };
    };
  };

  # Formatter: black
  plugins.conform-nvim.settings.formatters_by_ft = {
    python = [ "black" ];
  };
}
