{
  # Import all your configuration modules here
  imports = [
    ./auto-save.nix
    ./blink-cmp.nix
    ./catppuccin.nix
    ./dashboard.nix
    ./formatters.nix
    ./fzf.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lsp-keymaps.nix
    ./lualine.nix
    ./neo-tree.nix
    ./neogit.nix
    ./noice.nix
    ./persistence.nix
    ./tailwindcss.nix
    ./telescope.nix
    ./tiny-inline-diagnostic.nix
    ./treesitter.nix
    ./treesitter-textobjects.nix
    ./ts-autotag.nix
    ./vue-macros.nix
    ./which-key.nix
    ./yanky.nix
  ];

  globals.mapleader = " ";
}
