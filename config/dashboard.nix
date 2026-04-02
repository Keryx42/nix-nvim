{ pkgs, ... }:
{
  extraConfigLua = ''
    local ok, alpha = pcall(require, "alpha")
    local ascii_header = {
      "  _   _  ___  __  __ ",
      " | \\ | |/ _ \\|  \/  |",
      " |  \\| | | | | |\\/| |",
      " | |\\  | |_| | |  | |",
      " |_| \\_|\\___/|_|  |_|",
    }

    if ok then
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = ascii_header
      dashboard.section.buttons.val = {
        dashboard.button("f", "Find file", ":lua require('fzf-lua').files()<CR>"),
        dashboard.button("r", "Recent files", ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('data') })<CR>"),
        dashboard.button("c", "Config", ":edit $MYVIMRC<CR>"),
        dashboard.button("g", "Neogit", ":Neogit<CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.opts)
      -- Open dashboard on VimEnter when no files were passed
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.schedule(function() alpha.start(true) end)
          end
        end,
      })
      return
    end

    -- Fallback: internal lightweight dashboard (works without alpha)
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.defer_fn(function()
          if vim.fn.argc() ~= 0 then return end

          -- Open a new scratch buffer
          vim.cmd("enew")
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].buftype = "nofile"
          vim.bo[buf].bufhidden = "wipe"
          vim.bo[buf].swapfile = false
          vim.bo[buf].modifiable = true

          local header = ascii_header
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

          map('f', function()
            local okf, fzf = pcall(require, 'fzf-lua')
            if okf then fzf.files() else vim.cmd('Telescope find_files') end
          end)
          map('r', function()
            local okf, fzf = pcall(require, 'fzf-lua')
            if okf then fzf.files({ cwd = vim.fn.stdpath('data') }) else vim.cmd('Telescope oldfiles') end
          end)
          map('c', function() vim.cmd('edit ' .. vim.fn.expand('$MYVIMRC')) end)
          map('g', function() vim.cmd('Neogit') end)
          map('q', function() vim.cmd('qa') end)
        end, 50)
      end,
    })
  '';
}
