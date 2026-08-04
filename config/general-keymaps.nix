{
  # General editor keybindings (non-LSP, non-plugin specific)
  keymaps = [
    # Clear search highlighting when pressing Esc
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options = {
        desc = "Clear search highlighting";
        silent = true;
      };
    }
  ];
}
