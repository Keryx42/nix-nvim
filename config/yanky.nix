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
    -- Conditionally enable unnamedplus only on safe platforms:
    -- - macOS: enable
    -- - Linux: enable when X11 (DISPLAY) is present, or when Wayland has wl-copy available
    local function should_enable_unnamedplus()
      -- macOS
      if vim.fn.has('macunix') == 1 then
        return true
      end

      local ok, uname = pcall(function() return vim.loop.os_uname().sysname end)
      uname = (ok and uname) and uname or ''

      if uname == 'Linux' then
        -- X11 (DISPLAY) is generally safe
        if vim.env.DISPLAY ~= nil then
          return true
        end
        -- Wayland: enable only if wl-copy (wl-clipboard) is installed
        if vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable('wl-copy') == 1 then
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
