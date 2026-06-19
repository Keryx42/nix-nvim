{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.diffview-nvim ];

  extraConfigLua = ''
    require("diffview").setup({})
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<cr>";
      options = { desc = "Open Diffview"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<cr>";
      options = { desc = "Close Diffview"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>DiffviewFileHistory %<cr>";
      options = { desc = "File git history"; silent = true; };
    }
  ];
}
