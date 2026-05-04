{ pkgs, ... }:
{
  # Declarative clipboard provider configuration for multi-platform support.
  # Ensures clipboard helper tools are available but does NOT enforce global clipboard sync.
  #
  # Providers configured:
  # - macOS / Darwin: pbcopy/pbpaste (native)
  # - Linux X11: xclip (explicit Nix package)
  # - Linux Wayland: wl-copy/wl-paste (explicit Nix package)
  #
  # Global clipboard sync (vim.opt.clipboard = "unnamedplus") is handled conditionally
  # in yanky.nix to avoid freezes when providers are unavailable.

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
}
