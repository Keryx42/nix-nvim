{ pkgs, ... }:
{
  # Enable yanky.nvim for yank history and improved put behavior
  plugins.yanky = {
    enable = true;

    # Configure system clipboard handling via yanky's native settings
    # instead of manual vim.opt.clipboard to prevent resize freezes on Wayland
    settings.system_clipboard = {
      # Conditionally enable clipboard sync based on platform safety:
      # - macOS: true (pbcopy is native, always safe)
      # - Linux X11 (DISPLAY set): true (xclip is reliable)
      # - Linux Wayland: false (avoid blocking focus-event clipboard calls)
      # 
      # When disabled, yanky won't watch for external clipboard changes via
      # FocusGained/FocusLost events, preventing expensive wl-copy/wl-paste calls
      # that can block the main thread during window resize events.
      # 
      # The yank history ring still works on all platforms via <leader>p.
      sync_with_ring =
        if pkgs.stdenv.isDarwin then
          true
        else if pkgs.stdenv.isLinux then
          # X11: safe to enable if DISPLAY is set (xclip available)
          # Wayland: disable to prevent freezes (can't detect reliably at config time)
          # Default to false on Linux (safest for Wayland)
          false
        else
          false;
    };
  };

  # Enable system clipboard integration on macOS
  # vim.opt.clipboard = "unnamedplus" syncs unnamed register with system clipboard
  # Safe on macOS (pbcopy is native, no blocking calls) but disabled on Linux
  # to prevent freeze issues on Wayland with wl-copy/wl-paste
  vim.opt.clipboard = 
    if pkgs.stdenv.isDarwin then "unnamedplus" else "";

  # Provide a convenient mapping to open the yank history (normal + visual)
  keymaps = [
    {
      mode = "n";
      key = "<leader>p";
      action = "<cmd>YankyRingHistory<cr>";
      options = { desc = "Open Yank History"; silent = true; };
    }
    {
      mode = "x";
      key = "<leader>p";
      action = "<cmd>YankyRingHistory<cr>";
      options = { desc = "Open Yank History"; silent = true; };
    }
  ];
}
