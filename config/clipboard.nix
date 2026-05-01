{ pkgs, ... }:
{
  # Declarative clipboard provider configuration for multi-platform support
  # - macOS / Darwin: pbcopy/pbpaste (native)
  # - Linux X11: xclip (explicit Nix package)
  # - Linux Wayland: wl-copy/wl-paste (explicit Nix package)
  #
  # Neovim auto-detects DISPLAY and WAYLAND_DISPLAY at runtime to select the appropriate provider.
  # This eliminates unsafe global clipboard sync and prevents freezes on Wayland when wl-clipboard is unavailable.

  clipboard = {
    # macOS / Darwin: use native pbcopy/pbpaste
    providers.pbcopy.enable = pkgs.stdenv.isDarwin;

    # Linux X11: use xclip
    providers.xclip.enable = pkgs.stdenv.isLinux;
    providers.xclip.package = pkgs.xclip;

    # Linux Wayland: use wl-copy/wl-paste
    providers.wl-copy.enable = pkgs.stdenv.isLinux;
    providers.wl-copy.package = pkgs.wl-clipboard;
  };

  # Enable system clipboard integration (yanks sync to system clipboard)
  # nixvim's providers will handle this safely based on environment detection
  extraConfigLua = ''
    vim.opt.clipboard = "unnamedplus"
  '';
}
