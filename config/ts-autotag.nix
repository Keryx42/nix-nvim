{ pkgs, ... }:
{
  # nvim-ts-autotag automatically closes HTML and JSX tags
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-ts-autotag";
      src = pkgs.fetchFromGitHub {
        owner = "windwp";
        repo = "nvim-ts-autotag";
        rev = "8e1c0a389f20bf7f5b0dd0e00306c1247bda2595";
        hash = "sha256-a6xnl1IyKLMEeaw3OIuwdNx10HFPYxExVuGWAhaim+M=";
      };
    })
  ];

  extraConfigLua = ''
    require("nvim-ts-autotag").setup({})
  '';
}
