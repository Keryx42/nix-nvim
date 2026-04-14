{ ... }:
{
  # JSON sorting is now handled explicitly in lsp-keymaps.nix <C-s> keybinding
  # This chains: save → sort → format → lint for JSON files only
  # Auto-save does not trigger this chain (only explicit Ctrl+S)
  # Manual sort via <leader>cJ is still available
}

