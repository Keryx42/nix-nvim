{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "tiny-inline-diagnostic.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "rachartier";
        repo = "tiny-inline-diagnostic.nvim";
        rev = "main";
        hash = "sha256-mJl6yuTH79QsfKRktBGzPOlnL1x3/KoOAWyDGGw/AwM=";
      };
    })
  ];

  extraConfigLua = ''
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
      },
      blend = {
        factor = 0.27,
      },
      options = {
        show_source = true,
        throttle = 20,
        softwrap = 32,
      },
    })

    -- Disable default Neovim virtual text to avoid conflicts
    vim.diagnostic.config({
      virtual_text = false,
    })
  '';
}
