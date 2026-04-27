{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "tiny-inline-diagnostic.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "rachartier";
        repo = "tiny-inline-diagnostic.nvim";
        rev = "147af4e49f51dd48f41972de26552872b8ba7b25";
        hash = "sha256-LpZuRNGSK8AHLTIPIWoQlGot89qubFRL/RZ+EMs4bnQ=";
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
