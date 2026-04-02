{ pkgs, ... }:
{
  extraConfigLua = ''
    -- Custom lightweight dashboard (no alpha dependency)
    local logo_path = vim.fn.expand("~/.config/assets/logo.jpeg")

    local function try_show_kitty(path)
      if vim.fn.executable("kitty") == 1 then
        local cmd = string.format('kitty +kitten icat --transfer-mode=stream %q', path)
        -- Use os.execute so output goes to the terminal, not captured
        local ok = os.execute(cmd)
        return ok == 0 or ok == true
      end
      return false
    end

    local ascii_header = {
      "  _   _  ___  __  __ ",
      " | \\ | |/ _ \\|  \/  |",
      " |  \\| | | | | |\\/| |",
      " | |\\  | |_| | |  | |",
      " |_| \\_|\\___/|_|  |_|",
    }

    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.defer_fn(function()
          if vim.fn.argc() ~= 0 then return end

          local displayed = false
          if logo_path ~= "" then
            pcall(function() displayed = try_show_kitty(logo_path) end)
          end

          -- Open a new scratch buffer
          vim.cmd("enew")
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].buftype = "nofile"
          vim.bo[buf].bufhidden = "wipe"
          vim.bo[buf].swapfile = false
          vim.bo[buf].modifiable = true

          local header = displayed and {" "} or ascii_header
          local buttons = {
            "",
            "[f] Find file    [r] Recent files    [c] Config    [g] Neogit    [q] Quit",
            "",
            "Press the key in brackets to run the action",
          }

          local lines = {}
          for _, l in ipairs(header) do table.insert(lines, l) end
          for _, l in ipairs(buttons) do table.insert(lines, l) end

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].modifiable = false

          local map = function(lhs, fn)
            vim.keymap.set('n', lhs, fn, { buffer = buf, silent = true, nowait = true })
          end

          map('f', function() require('fzf-lua').files() end)
          map('r', function() require('fzf-lua').files({ cwd = vim.fn.stdpath('data') }) end)
          map('c', function() vim.cmd('edit ' .. vim.fn.expand('$MYVIMRC')) end)
          map('g', function() vim.cmd('Neogit') end)
          map('q', function() vim.cmd('qa') end)
        end, 50)
      end,
    })
  '';
}
