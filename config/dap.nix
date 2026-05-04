{ ... }:
{
  # Enable yanky.nvim for yank history and improved put behavior
  plugins.dap = {
    enable = true;
  };

  plugins.dap-ui = {
    enable = true;
  };

  # keymaps = [
  #   {
  #     mode = "n";
  #     key = "<leader>p";
  #     action = "<cmd>YankyRingHistory<cr>";
  #     options = { desc = "Open Yank History"; silent = true; };
  #   }
  #   {
  #     mode = "x";
  #     key = "<leader>p";
  #     action = "<cmd>YankyRingHistory<cr>";
  #     options = { desc = "Open Yank History"; silent = true; };
  #   }
  # ];
}
