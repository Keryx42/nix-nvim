{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "mini-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-mini";
        repo = "mini.nvim";
        rev = "HEAD";
        hash = "sha256-bHEFu4XZI9QHP41h11sSNgRG43PDSkdgTyzmJt64gLk=";
      };
    })
  ];

  extraConfigLua = ''
    require("mini.pairs").setup()
  '';
}
