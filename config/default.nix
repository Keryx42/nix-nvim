{
  # Import all your configuration modules here
  imports = [
    ./preinit.nix
    ./catppuccin.nix
    ./lualine.nix
    ./neo-tree.nix
    ./fzf.nix
    ./neogit.nix
    ./gitsigns.nix
    ./dashboard.nix
    ./auto-save.nix
    ./treesitter.nix
    ./lsp.nix
    ./formatters.nix
    ./which-key.nix
    ./vue-macros.nix
    ./lsp-keymaps.nix
    ./yanky.nix
  ];

  globals.mapleader = " ";
}
