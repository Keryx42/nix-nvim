{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "auto-save-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "okuuva";
        repo = "auto-save.nvim";
        rev = "v1.1.0";
        hash = "sha256-ns7MB6eg6HK5tMczsRFC2UXT8/ttv+EBw+S/ma8o4PE=";
      };
    })
  ];

  extraConfigLua = ''
    require("auto-save").setup({
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = {},
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = nil,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000,
      debug = false,
    })
  '';
}
