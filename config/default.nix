{
  # Import all your configuration modules here
  imports = [
    ./catppuccin.nix
    ./dashboard.nix
    ./lualine.nix
    ./neo-tree.nix
    ./fzf.nix
    ./neogit.nix
    ./gitsigns.nix
    ./auto-save.nix
    ./tiny-inline-diagnostic.nix
    ./telescope.nix
    ./treesitter.nix
    ./treesitter-textobjects.nix
    ./ts-autotag.nix
    ./lsp.nix
    ./formatters.nix
    ./which-key.nix
    ./vue-macros.nix
    ./lsp-keymaps.nix
    ./yanky.nix
    ./persistence.nix
  ];

  globals.mapleader = " ";
}
