{
  plugins.neo-tree = {
    enable = true;
    settings.filesystem.follow_current_file.enabled = true;
  };

  # Ensure Neovim runtime data/cache directories exist at startup so plugins
  # that try to open log files (neo-tree, etc.) don't error during flake checks.
  extraConfigLua = ''
    local data = vim.fn.stdpath('data')
    if vim.fn.isdirectory(data) == 0 then vim.fn.mkdir(data, 'p') end
    local cache = vim.fn.stdpath('cache')
    if vim.fn.isdirectory(cache) == 0 then vim.fn.mkdir(cache, 'p') end
  '';

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
