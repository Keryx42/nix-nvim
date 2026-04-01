{
  # Import all your configuration modules here
  imports = [
    ./catppuccin.nix
    ./bufferline.nix
    ./lualine.nix
    ./neo-tree.nix
    ./fzf.nix
    ./neogit.nix
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
