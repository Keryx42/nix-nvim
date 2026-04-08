{ pkgs, ... }:
{
  plugins.noice = {
    enable = true;

    settings = {
      # Cmdline configuration - centered floating popup
      cmdline = {
        enabled = true;
        view = "cmdline_popup";

        opts = {
          position = {
            row = "50%";
            col = "50%";
          };
          size = {
            width = 60;
            height = "auto";
          };
        };

        format = {
          cmdline = {
            pattern = "^:";
            icon = " ";
            lang = "vim";
          };
          search_down = {
            kind = "search";
            pattern = "^/";
            icon = " ";
            lang = "regex";
          };
          search_up = {
            kind = "search";
            pattern = "^%?";
            icon = " ";
            lang = "regex";
          };
          filter = {
            pattern = "^:%s*!";
            icon = "$";
            lang = "bash";
          };
          lua = {
            pattern = [
              "^:%s*lua%s+"
              "^:%s*lua%s*=%s*"
              "^:%s*=%s*"
            ];
            icon = "";
            lang = "lua";
          };
          help = {
            pattern = "^:%s*he?l?p?%s+";
            icon = "";
          };
          input = {
            view = "cmdline_input";
            icon = "󰥻 ";
          };
        };
      };

      # Messages configuration
      messages = {
        enabled = true;
        view = "notify";
        view_error = "notify";
        view_warn = "notify";
        view_history = "messages";
        view_search = "virtualtext";
      };

      # Popupmenu configuration
      popupmenu = {
        enabled = true;
        backend = "nui";
        kind_icons = {};
      };

      # LSP configuration
      lsp = {
        progress = {
          enabled = true;
          format = "lsp_progress";
          format_done = "lsp_progress_done";
          throttle = 1000 / 30;
          view = "mini";
        };

        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };

        hover = {
          enabled = true;
          silent = false;
        };

        signature = {
          enabled = true;
          auto_open = {
            enabled = true;
            trigger = true;
            throttle = 50;
          };
        };

        message = {
          enabled = true;
          view = "notify";
        };

        documentation = {
          view = "hover";
          opts = {
            lang = "markdown";
            replace = true;
            render = "plain";
            format = [ "{message}" ];
            win_options = {
              concealcursor = "n";
              conceallevel = 3;
            };
          };
        };
      };

      # Notify configuration
      notify = {
        enabled = true;
        view = "notify";
      };

      # Custom routes for message handling
      routes = [
        {
          filter = {
            event = "msg_show";
            kind = "search_count";
          };
          opts = {
            skip = true;
          };
        }
      ];

      # Presets
      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = false;
      };

      # Health check
      health = {
        checker = true;
      };

      throttle = 1000 / 30;
    };
  };

  # Dependencies
  extraPlugins = with pkgs.vimPlugins; [
    nui-nvim
  ];
}
