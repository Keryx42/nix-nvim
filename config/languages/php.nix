{ pkgs, ... }:
{
  # PHP with Laravel and Blade support
  # Includes TreeSitter grammars (php, phpdoc, blade), phpactor LSP, and pint formatter

  # Note: TreeSitter grammars are configured centrally in config/treesitter.nix

  # LSP servers and settings
  plugins.lsp.servers.phpactor = {
    enable = true;
    filetypes = [ "php" "blade" ];
  };

  # Formatters: pint for PHP and Blade (Laravel's opinionated code style fixer)
  plugins.conform-nvim.settings.formatters_by_ft = {
    php = [ "pint" ];
    blade = [ "pint" ];
  };

  # Configure filetypes for Blade templates (.blade.php files)
  # Blade files get syntax highlighting via TreeSitter blade grammar
  # and LSP features (completion, go-to-def, etc.) via phpactor
  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        ["blade.php"] = "blade",
      },
      pattern = {
        [".*\\.blade\\.php$"] = "blade",
      },
    })
  '';
}
