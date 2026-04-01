{ pkgs, ... }:
{
  plugins.none-ls = {
    enable = true;

    sources.formatting.prettier = {
      enable = true;
      package = pkgs.nodePackages.prettier;
    };
  };
}
