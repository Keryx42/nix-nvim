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
      condition = function(buffer_handle)
        local buffer_name = vim.api.nvim_buf_get_name(buffer_handle)
        local buffer_tail = vim.fn.fnamemodify(buffer_name, ':t')
        return vim.bo[buffer_handle].buftype == ""
          and vim.bo[buffer_handle].modified
          and buffer_name ~= ""
          and not buffer_tail:match("^neo%-tree")
      end,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000,
      debug = false,
    })
  '';
}
