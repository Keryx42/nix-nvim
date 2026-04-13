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

  # Notification history picker with clipboard copy
  keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action.__raw = ''
        function()
          local noice = require("noice")
          local history = require("noice.history").get()
          
          -- Format messages for fzf picker
          local messages = {}
          for i, msg in ipairs(history) do
            -- Determine severity level string
            local level_str = "INFO"
            if msg.level then
              if msg.level == vim.log.levels.ERROR then
                level_str = "ERROR"
              elseif msg.level == vim.log.levels.WARN then
                level_str = "WARN"
              elseif msg.level == vim.log.levels.DEBUG then
                level_str = "DEBUG"
              elseif msg.level == vim.log.levels.TRACE then
                level_str = "TRACE"
              end
            end
            
            -- Get message text (handle multi-line by taking first line)
            local message_text = msg.message or ""
            local first_line = message_text:match("([^\n]*)")
            
            -- Format: [LEVEL] Message text
            local formatted = string.format("[%s] %s", level_str, first_line)
            table.insert(messages, {
              display = formatted,
              full_message = message_text,
              level = level_str,
            })
          end
          
          -- Reverse to show newest first
          messages = vim.fn.reverse(messages)
          
          if #messages == 0 then
            vim.notify("No notifications in history", vim.log.levels.INFO)
            return
          end
          
          -- Open fzf-lua picker with custom action
          require("fzf-lua").fzf_exec(
            function(cb)
              for _, msg in ipairs(messages) do
                cb(msg.display)
              end
              cb(nil) -- Signal end of input
            end,
            {
              prompt = "Notifications> ",
              actions = {
                default = function(selected)
                  if not selected or #selected == 0 then
                    return
                  end
                  
                  -- Find the corresponding message
                  local selected_text = selected[1]
                  local target_msg = nil
                  for _, msg in ipairs(messages) do
                    if msg.display == selected_text then
                      target_msg = msg
                      break
                    end
                  end
                  
                  if target_msg then
                    -- Copy full message to clipboard
                    vim.fn.setreg("+", target_msg.full_message)
                    vim.notify(
                      string.format("Copied [%s] notification to clipboard", target_msg.level),
                      vim.log.levels.INFO
                    )
                  end
                end,
              },
            }
          )
        end
      '';
      options = {
        desc = "Notification History";
        silent = true;
      };
    }
  ];
}
