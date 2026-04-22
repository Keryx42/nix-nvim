{
  # General editor keybindings (non-LSP, non-plugin specific)

  extraConfigLua = ''
    -- Clear search highlighting and close all floating windows on ESC
    vim.keymap.set("n", "<Esc>", function()
      vim.cmd("nohlsearch")
      
      -- Close any floating windows (hover popups, diagnostics, etc.)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then  -- floating window
          vim.api.nvim_win_close(win, false)
        end
      end
    end, { silent = true, noremap = true, desc = "Clear search highlighting and close floating windows" })
  '';
}
