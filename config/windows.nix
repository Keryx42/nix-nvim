{
  # Window and split management keymaps (LazyVim-style)

  keymaps = [
    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>wincmd h<cr>";
      options = { desc = "Go to left window"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>wincmd j<cr>";
      options = { desc = "Go to lower window"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>wincmd k<cr>";
      options = { desc = "Go to upper window"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>wincmd l<cr>";
      options = { desc = "Go to right window"; silent = true; };
    }

    # Window resizing
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +5<cr>";
      options = { desc = "Increase window height"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -5<cr>";
      options = { desc = "Decrease window height"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -5<cr>";
      options = { desc = "Decrease window width"; silent = true; };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +5<cr>";
      options = { desc = "Increase window width"; silent = true; };
    }

    # Split creation
    {
      mode = "n";
      key = "<leader>-";
      action = "<cmd>split<cr>";
      options = { desc = "Split window below"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<cmd>vsplit<cr>";
      options = { desc = "Split window right"; silent = true; };
    }

    # Window management
    {
      mode = "n";
      key = "<leader>wd";
      action = "<cmd>close<cr>";
      options = { desc = "Delete window"; silent = true; };
    }
  ];
}
