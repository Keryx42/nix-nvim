{ pkgs, ... }:
{
  # Enable yanky.nvim for yank history and improved put behavior
  plugins.yanky = {
    enable = true;
    settings = {
      system_clipboard = {
        sync_with_ring = true;
      };
    };
  };

  # Provide a convenient mapping to open the yank history (normal + visual)
  keymaps = [
    {
      mode = "n";
      key = "<leader>p";
      action = "<cmd>YankyRingHistory<cr>";
      options = { desc = "Open Yank History"; silent = true; };
    }
    {
      mode = "x";
      key = "<leader>p";
      action = "<cmd>YankyRingHistory<cr>";
      options = { desc = "Open Yank History"; silent = true; };
    }
  ];

  extraConfigLua = ''
    -- Make all yanks copy to the system clipboard (unnamedplus)
    vim.opt.clipboard = "unnamedplus"
  '';
}  
