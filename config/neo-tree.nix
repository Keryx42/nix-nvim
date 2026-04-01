{
  plugins.neo-tree = {
    enable = true;
    filesystem.followCurrentFile.enabled = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle reveal<cr>";
      options = {
        desc = "Toggle Neo-tree (root dir)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "function() vim.cmd('Neotree toggle reveal dir=' .. vim.fn.expand('%:p:h')) end";
      options = {
        desc = "Toggle Neo-tree (cwd)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Neotree reveal<cr>";
      options = {
        desc = "Focus Neo-tree (root dir)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fE";
      action.__raw = "function() vim.cmd('Neotree reveal dir=' .. vim.fn.expand('%:p:h')) end";
      options = {
        desc = "Focus Neo-tree (cwd)";
        silent = true;
      };
    }
  ];
}
