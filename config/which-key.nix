{ pkgs, ... }:
{
  plugins.which-key = {
    enable = true;
  };

  extraConfigLua = ''
    local wk = require("which-key")

    wk.setup({
      preset = "classic",
      icons = { mappings = false },
    })

      wk.add({
        { "<leader> ", desc = "Find files (root dir)" },
      { "<leader>/", desc = "Grep current buffer" },
      { "<leader>E", desc = "Toggle Neo-tree (cwd)" },
      { "<leader>e", desc = "Toggle Neo-tree (root dir)" },
      { "<leader>f", group = "Find" },
      { "<leader>fE", desc = "Focus Neo-tree (cwd)" },
      { "<leader>fF", desc = "Find files (cwd)" },
      { "<leader>fG", desc = "Grep (cwd)" },
      { "<leader>fe", desc = "Focus Neo-tree (root dir)" },
      { "<leader>ff", desc = "Find files (root dir)" },
      { "<leader>fg", desc = "Grep (root dir)" },
      { "<leader>g", group = "Git" },
      { "<leader>gu", desc = "Open Neogit" },
      -- gitsigns mappings grouped under <leader>g h (Hunks)
      { "<leader>gh", group = "Hunks" },
      { "<leader>ghs", desc = "Stage current hunk" },
      { "<leader>ghr", desc = "Reset current hunk" },
      { "<leader>ghS", desc = "Stage buffer" },
      { "<leader>ghR", desc = "Reset buffer" },
      { "<leader>ghp", desc = "Preview hunk" },
       { "<leader>ghb", desc = "Blame line (full)" },
       { "]h", desc = "Next git hunk" },
       { "[h", desc = "Prev git hunk" },
       { "<leader>s", group = "Search" },
       { "<leader>sg", desc = "Grep (root dir)" },
       { "<leader>sm", desc = "Modified files" },
      { "<leader>m", group = "Macros" },
      { "<leader>ms", desc = "Wrap StoreToRefs" },
      { "<leader>mc", desc = "Wrap Composable" },
      { "<leader>mj", desc = "Go To Definition Alias" },
      { "<leader>mp", desc = "Props to Refs" },
      { "<leader>ma", desc = "Destruct" },
        { "<leader>c", group = "LSP" },
        { "<leader>ca", desc = "Code Action (Telescope)" },
        { "<leader>cA", desc = "Code Action (Fixable)" },
        { "<leader>cF", desc = "Apply fixAll (auto)" },
        { "<leader>cf", desc = "Format buffer" },
        { "<leader>cr", desc = "Rename symbol" },
        { "<leader>cR", desc = "Rename file" },
        { "<leader>cd", desc = "Line diagnostics" },
        { "<leader>cs", desc = "Symbols (Trouble)" },
        { "<leader>cS", desc = "LSP Definitions / references / ... (Trouble)" },
        { "<leader>q", group = "Quit" },
        { "<leader>qq", desc = "Quit All" },
        { "<leader>x", group = "Trouble" },
        { "<leader>xx", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>xL", desc = "Location List (Trouble)" },
        { "<leader>xQ", desc = "Quickfix List (Trouble)" },
        { "<leader>xl", desc = "Diagnostics → loclist" },
       { "<leader>p", desc = "Open Yank History" },
       { "[q", desc = "Previous Trouble/Quickfix Item" },
       { "]q", desc = "Next Trouble/Quickfix Item" },
       { "gd", desc = "Go to definition (LSP)" },
       { "gD", desc = "Go to declaration (LSP)" },
    })
  '';
}
