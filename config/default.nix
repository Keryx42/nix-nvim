{
  # Import all your configuration modules here
  imports = [
    # Core editor features
    ./auto-save.nix
    ./blink-cmp.nix
    ./catppuccin.nix
    ./conform.nix
    ./dashboard.nix
    ./fzf.nix
    ./general-keymaps.nix
    ./godot.nix
    ./gitsigns.nix
    ./harpoon.nix
    ./lualine.nix
    ./mini-pairs.nix
    ./neo-tree.nix
    ./neogit.nix
    ./noice.nix
    ./persistence.nix
    ./spider.nix
    ./tailwindcss.nix
    ./telescope.nix
    ./terminal-title.nix
    ./tiny-inline-diagnostic.nix
    ./treesitter.nix
    ./treesitter-textobjects.nix
    ./ts-autotag.nix
    ./vue-macros.nix
    ./which-key.nix
    ./yanky.nix

    # Language support (unified per-language files with LSP + formatters)
    # Note: TreeSitter grammars are centralized in treesitter.nix
    ./languages/_shared.nix
    ./languages/web.nix
    ./languages/nix.nix
    ./languages/json.nix
    ./languages/markdown.nix
    ./languages/python.nix

    # Cross-cutting tools
    ./tools/linting.nix
    ./tools/lsp-rename.nix
    ./tools/lsp-keymaps.nix
    ./tools/json-sort-auto.nix
  ];

  globals.mapleader = " ";
}
