{
  # Import all your configuration modules here
  imports = [
    ./auto-save.nix
    ./blink-cmp.nix
    ./catppuccin.nix
    ./conform.nix
    ./dashboard.nix
    ./fzf.nix
    ./gitsigns.nix
    ./json-lsp.nix
    ./lint.nix
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
