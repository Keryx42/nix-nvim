{
  # Trouble.nvim - Pretty list for diagnostics, references, quickfix, location lists
  # Provides organized viewing and navigation of LSP diagnostics and search results

  plugins.trouble = {
    enable = true;
    settings = {
      focus = true;
      modes = {
        lsp = {
          focus = false;
        };
      };
    };
  };

  keymaps = [
    # Diagnostics
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options = {
        desc = "Diagnostics (Trouble)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options = {
        desc = "Buffer Diagnostics (Trouble)";
        silent = true;
      };
    }
    # LSP
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols (Trouble)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cS";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options = {
        desc = "LSP Definitions / references / ... (Trouble)";
        silent = true;
      };
    }
    # Location and Quickfix lists
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options = {
        desc = "Location List (Trouble)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options = {
        desc = "Quickfix List (Trouble)";
        silent = true;
      };
    }
    # Navigation
    {
      mode = "n";
      key = "[q";
      action = "<cmd>Trouble prev<cr>";
      options = {
        desc = "Previous Trouble/Quickfix Item";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "]q";
      action = "<cmd>Trouble next<cr>";
      options = {
        desc = "Next Trouble/Quickfix Item";
        silent = true;
      };
    }
  ];
}
