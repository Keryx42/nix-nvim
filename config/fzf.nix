{
  plugins.fzf-lua = {
    enable = true;
    keymaps = {
      "<leader><space>" = {
        action = "files";
        options = {
          desc = "Find files (root dir)";
          silent = true;
        };
      };
      "<leader>ff" = {
        action = "files";
        options = {
          desc = "Find files (root dir)";
          silent = true;
        };
      };
      "<leader>fg" = {
        action = "live_grep";
        options = {
          desc = "Grep (root dir)";
          silent = true;
        };
      };
      "<leader>sg" = {
        action = "live_grep";
        options = {
          desc = "Grep (root dir)";
          silent = true;
        };
      };
      "<leader>/" = {
        action = "lgrep_curbuf";
        options = {
          desc = "Grep current buffer";
          silent = true;
        };
      };
    };
  };

  # Register fzf-lua as the global vim.ui.select backend
  extraConfigLua = ''
    require('fzf-lua').register_ui_select()
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>fF";
      action.__raw = "function() require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') }) end";
      options = {
        desc = "Find files (cwd)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fG";
      action.__raw = "function() require('fzf-lua').live_grep({ cwd = vim.fn.expand('%:p:h') }) end";
      options = {
        desc = "Grep (cwd)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sm";
      action.__raw = ''function()
        local fzf = require('fzf-lua')
        -- Get unstaged modified files
        local unstaged = vim.fn.systemlist('git diff --name-only --diff-filter=M 2>/dev/null')
        -- Get staged modified files
        local staged = vim.fn.systemlist('git diff --cached --name-only --diff-filter=M 2>/dev/null')
        -- Combine and deduplicate
        local files = {}
        local seen = {}
        for _, f in ipairs(vim.list_extend(unstaged, staged)) do
          if not seen[f] then
            table.insert(files, f)
            seen[f] = true
          end
        end
        if #files == 0 then
          vim.notify("No modified files found", vim.log.levels.INFO)
        else
          fzf.fzf_exec(files, {
            prompt = "Modified Files> ",
            actions = {
              ["default"] = fzf.actions.file_edit,
            },
          })
        end
      end'';
      options = {
        desc = "Search modified files";
        silent = true;
      };
    }
  ];
}
