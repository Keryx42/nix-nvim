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
      "<leader>/" = {
        action = "lgrep_curbuf";
        options = {
          desc = "Grep current buffer";
          silent = true;
        };
      };
    };
  };

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
  ];
}
