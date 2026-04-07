{ pkgs, ... }:
{
  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };
    settings = {
      defaults = {
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            preview_width = 0.6;
          };
        };
        sorting_strategy = "ascending";
        prompt_prefix = "   ";
        selection_caret = "  ";
      };
      pickers = {
        buffers = {
          sort_lastused = true;
          ignore_current_buffer = true;
        };
      };
    };
  };
}
