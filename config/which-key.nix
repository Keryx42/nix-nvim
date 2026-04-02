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
      -- g (normal) mappings from gitsigns
      { "g", group = "Git (g)" },
      { "ghs", desc = "Stage current hunk" },
      { "ghr", desc = "Reset current hunk" },
      { "ghS", desc = "Stage buffer" },
      { "ghR", desc = "Reset buffer" },
      { "ghp", desc = "Preview hunk" },
      { "ghb", desc = "Blame line (full)" },
      { "]h", desc = "Next git hunk" },
      { "[h", desc = "Prev git hunk" },
      { "<leader>s", group = "Search" },
      { "<leader>sg", desc = "Grep (root dir)" },
      { "<leader>m", group = "Macros" },
      { "<leader>ms", desc = "Wrap StoreToRefs" },
      { "<leader>mc", desc = "Wrap Composable" },
      { "<leader>mj", desc = "Go To Definition Alias" },
      { "<leader>mp", desc = "Props to Refs" },
      { "<leader>ma", desc = "Destruct" },
      { "<leader>c", group = "LSP" },
      { "<leader>ca", desc = "Code Action" },
      { "<leader>cA", desc = "Apply fixAll (eslint if available)" },
      { "<leader>cf", desc = "Format buffer" },
      { "<leader>cr", desc = "Rename symbol" },
      { "<leader>cd", desc = "Line diagnostics" },
      { "<leader>xl", desc = "Diagnostics → loclist" },
      { "<leader>p", desc = "Open Yank History" },
    })
  '';
}
