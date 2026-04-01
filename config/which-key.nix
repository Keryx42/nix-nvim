{ pkgs, ... }:
{
  plugins.which-key = {
    enable = true;
  };

  extraConfigLua = ''
    local wk = require("which-key")

    wk.setup({
      window = { border = "rounded" },
      triggers = "auto",
      plugins = { marks = true, registers = true, spelling = { enabled = true } },
      defaults = { buffer = nil },
    })

    wk.register({
      [" "] = "Find files (root dir)",
      e = "Toggle Neo-tree (root dir)",
      E = "Toggle Neo-tree (cwd)",
      ["/"] = "Grep current buffer",
      f = {
        name = "Find",
        f = "Find files (root dir)",
        F = "Find files (cwd)",
        g = "Grep (root dir)",
        G = "Grep (cwd)",
        e = "Focus Neo-tree (root dir)",
        E = "Focus Neo-tree (cwd)",
      },
      g = {
        name = "Git",
        u = "Open Neogit",
      },
      s = {
        name = "Search",
        g = "Grep (root dir)",
      },
    }, { prefix = "<leader>" })
  '';
}
