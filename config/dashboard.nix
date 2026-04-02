{ pkgs, ... }:
{
  plugins."goolord/alpha-nvim".enable = true;

  extraConfigLua = ''
    -- Alpha dashboard with Kitty image support (best-effort)
    local ok, alpha = pcall(require, "alpha")
    if not ok then return end
    local dashboard = require("alpha.themes.dashboard")

    local logo_path = vim.fn.expand("~/.config/assets/logo.jpeg")

    local function try_kitty_icat(path)
      if vim.fn.executable("kitty") == 1 then
        local cmd = string.format('kitty +kitten icat --transfer-mode=stream %q', path)
        -- attempt to run icat; ignore errors
        local res = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then return true end
      end
      return false
    end

    local function b64_encode(data)
      local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
      return ((data:gsub(".", function(x)
        local r, bits = string.byte(x), ""
        for i = 8, 1, -1 do bits = bits .. (r % 2^i - r % 2^(i-1) > 0 and "1" or "0") end
        return bits
      end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if #x < 6 then return "" end
        local c = 0
        for i = 1, 6 do c = c * 2 + (x:sub(i, i) == "1" and 1 or 0) end
        return b:sub(c+1, c+1)
      end) .. ({ "", "==", "=" })[#data % 3 + 1]
    end

    local function emit_kitty_image_b64(path)
      local f = io.open(path, 'rb')
      if not f then return false end
      local data = f:read('*a')
      f:close()
      local b64 = b64_encode(data)
      local esc = string.char(27)
      -- compose kitty inline image sequence
      local header = esc .. '_Gf=100,t=d;' .. ' ' -- f=100 quality, t=d raw
      local tail = esc .. '\\'
      -- write to stdout so terminal renders it
      pcall(function() io.write(header .. b64 .. tail) end)
      return true
    end

    local displayed = false
    if logo_path and logo_path ~= "" then
      displayed = try_kitty_icat(logo_path)
      if not displayed then
        pcall(emit_kitty_image_b64, logo_path)
      end
    end

    if displayed then
      dashboard.section.header.val = { ' ' }
    else
      dashboard.section.header.val = {
        '  _   _  ___  __  __ ',
        ' | \ | |/ _ \|  \/  |',
        ' |  \| | | | | |\/| |',
        ' | |\  | |_| | |  | |',
        ' |_| \_|\___/|_|  |_|',
      }
    end

    dashboard.section.buttons.val = {
      dashboard.button('f', '󰈞  Find file', ":lua require('fzf-lua').files()<CR>"),
      dashboard.button('r', '  Recent files', ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('data') })<CR>"),
      dashboard.button('c', '  Config', ':edit $MYVIMRC<CR>'),
      dashboard.button('g', '  Neogit', ':Neogit<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    alpha.setup(dashboard.config)
  '';
}
