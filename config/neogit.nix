{
  plugins.neogit.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>gu";
      action = "<cmd>Neogit<cr>";
      options = {
        desc = "Open Neogit";
        silent = true;
      };
    }
  ];
}
