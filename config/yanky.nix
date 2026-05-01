{ pkgs, ... }:
{
  # Enable yanky.nvim for yank history and improved put behavior
  plugins.yanky = {
    enable = true;
  };

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

  extraConfigLua = ''
    -- Conditionally enable clipboard sync only on safe platforms to prevent freezes.
    --
    -- Problem: vim.opt.clipboard = "unnamedplus" makes Neovim call external clipboard
    -- helpers (pbcopy, xclip, wl-copy) on every yank/redraw. If the helper is unavailable
    -- or misconfigured, this can block the main thread during window resize events.
    --
    -- Solution: Enable unnamedplus only when:
    -- - macOS: pbcopy is native/always available
    -- - Linux X11: xclip/xsel is available (DISPLAY set)
    -- - Linux Wayland: wl-copy/wl-paste is available (wl-clipboard package)
    -- Otherwise: Disable to prevent freezes. Users can still yank manually via mappings.
    local function should_enable_unnamedplus()
      -- macOS: pbcopy is native, always safe
      if vim.fn.has("macunix") == 1 then
        return true
      end

      local ok, uname = pcall(function() return vim.loop.os_uname().sysname end)
      uname = (ok and uname) and uname or ""

      if uname == "Linux" then
        -- X11: safe if DISPLAY is set (xclip/xsel available from clipboard.nix)
        if vim.env.DISPLAY ~= nil then
          return true
        end
        -- Wayland: safe only if wl-copy is available
        if vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable("wl-copy") == 1 then
          return true
        end
      end

      return false
    end

    if should_enable_unnamedplus() then
      vim.opt.clipboard = "unnamedplus"
    end
  '';
}
