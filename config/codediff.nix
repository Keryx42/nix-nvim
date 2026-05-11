{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "codediff-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "esmuellert";
        repo = "codediff.nvim";
        rev = "8afc229d38dc13ce71b2ffbb860084b2c726e061";
        hash = "sha256-gaPLjH33+nBgpSZJ8b/4aneodt8wg+Jy44yXAjemToA=";
      };
      doCheck = false;
    })
  ];
}
