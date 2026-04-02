{ pkgs, ... }:
{
  # Enable alpha (LazyVim-like dashboard plugin)
  plugins.alpha-nvim.enable = true;

  extraConfigLua = ''
    local ok, alpha = pcall(require, "alpha")
    if not ok then
      return
    end

    local dashboard = require("alpha.themes.dashboard")

    local ascii_header = {
      "  _   _  ___  __  __ ",
      " | \\ | |/ _ \\|  \/  |",
      " |  \\| | | | | |\\/| |",
      " | |\\  | |_| | |  | |",
      " |_| \\_|\\___/|_|  |_|",
    }

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
  '';
}
