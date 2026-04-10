{
  plugins.harpoon = {
    enable = true;
  };

  keymaps = [
    # Add file to harpoon
    {
      mode = "n";
      key = "<leader>H";
      action.__raw = "function() require('harpoon'):list():append() end";
      options = {
        desc = "Add file to harpoon";
        silent = true;
      };
    }
    # Toggle harpoon quick menu
    {
      mode = "n";
      key = "<leader>h";
      action.__raw = "function() local harpoon = require('harpoon') harpoon.ui:toggle_quick_menu(harpoon:list()) end";
      options = {
        desc = "Toggle harpoon menu";
        silent = true;
      };
    }
    # Navigate to harpoon file 1
    {
      mode = "n";
      key = "<leader>1";
      action.__raw = "function() require('harpoon'):list():select(1) end";
      options = {
        desc = "Harpoon file 1";
        silent = true;
      };
    }
    # Navigate to harpoon file 2
    {
      mode = "n";
      key = "<leader>2";
      action.__raw = "function() require('harpoon'):list():select(2) end";
      options = {
        desc = "Harpoon file 2";
        silent = true;
      };
    }
    # Navigate to harpoon file 3
    {
      mode = "n";
      key = "<leader>3";
      action.__raw = "function() require('harpoon'):list():select(3) end";
      options = {
        desc = "Harpoon file 3";
        silent = true;
      };
    }
    # Navigate to harpoon file 4
    {
      mode = "n";
      key = "<leader>4";
      action.__raw = "function() require('harpoon'):list():select(4) end";
      options = {
        desc = "Harpoon file 4";
        silent = true;
      };
    }
    # Navigate to harpoon file 5
    {
      mode = "n";
      key = "<leader>5";
      action.__raw = "function() require('harpoon'):list():select(5) end";
      options = {
        desc = "Harpoon file 5";
        silent = true;
      };
    }
    # Navigate to harpoon file 6
    {
      mode = "n";
      key = "<leader>6";
      action.__raw = "function() require('harpoon'):list():select(6) end";
      options = {
        desc = "Harpoon file 6";
        silent = true;
      };
    }
    # Navigate to harpoon file 7
    {
      mode = "n";
      key = "<leader>7";
      action.__raw = "function() require('harpoon'):list():select(7) end";
      options = {
        desc = "Harpoon file 7";
        silent = true;
      };
    }
    # Navigate to harpoon file 8
    {
      mode = "n";
      key = "<leader>8";
      action.__raw = "function() require('harpoon'):list():select(8) end";
      options = {
        desc = "Harpoon file 8";
        silent = true;
      };
    }
    # Navigate to harpoon file 9
    {
      mode = "n";
      key = "<leader>9";
      action.__raw = "function() require('harpoon'):list():select(9) end";
      options = {
        desc = "Harpoon file 9";
        silent = true;
      };
    }
  ];

  # FZF-lua integration for harpoon picker
  extraConfigLua = ''
    local harpoon = require('harpoon')
    
    -- Register fzf-lua picker for harpoon
    if pcall(require, 'fzf-lua') then
      local fzf = require('fzf-lua')
      local harpoon_files = function()
        local list = harpoon:list()
        if not list or #list.items == 0 then
          vim.notify('No harpoon marks yet', vim.log.levels.WARN)
          return
        end
        
        local items = {}
        for idx, item in ipairs(list.items) do
          table.insert(items, string.format('%d: %s', idx, item.value))
        end
        
        fzf.fzf_exec(items, {
          actions = {
            default = function(selected)
              if selected and selected[1] then
                local idx = tonumber(selected[1]:match('^%d+'))
                if idx then
                  list:select(idx)
                end
              end
            end,
          },
          prompt = 'Harpoon> ',
          winopts = {
            preview = {
              default = 'builtin',
            }
          }
        })
      end
      
      -- Optional: bind <leader>M to open harpoon with fzf picker
      vim.keymap.set('n', '<leader>M', harpoon_files, { desc = 'Harpoon files (fzf)', silent = true })
    end
  '';
}
