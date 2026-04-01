{ pkgs, ... }:
{
  plugins.none-ls = {
    enable = true;

    sources.formatting.prettier = {
      enable = true;
      package = pkgs.nodePackages.prettier;
    };

    sources.formatting.nixfmt.enable = true;
    sources.diagnostics.statix.enable = true;
    sources.diagnostics.deadnix.enable = true;
  };
}
