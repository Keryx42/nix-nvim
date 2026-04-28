{ pkgs, ... }:
{
  # PHP with Laravel and Blade support
  # Includes TreeSitter grammars, phpactor LSP, and pint formatter

  # Note: TreeSitter grammars are configured centrally in config/treesitter.nix

  # LSP servers and settings
  plugins.lsp.servers.phpactor = {
    enable = true;
    filetypes = [ "php" ];
  };

  # Formatters: pint for PHP (Laravel's opinionated code style fixer)
  plugins.conform-nvim.settings.formatters_by_ft = {
    php = [ "pint" ];
  };
}
