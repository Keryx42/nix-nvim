{
  # General editor keybindings (non-LSP, non-plugin specific)

  extraConfigLua = ''
    -- Clear search highlighting and close which-key when pressing Esc
    local wk = require("which-key")
    vim.keymap.set("n", "<Esc>", function()
      vim.cmd("nohlsearch")
      wk.close()
    end, { silent = true, noremap = true, desc = "Clear search highlighting and close which-key" })
  '';
}
