{ pkgs, ... }:
{
  plugins.gitsigns.enable = true;

  keymaps = [
    # Next hunk (respect diff windows)
    {
      mode = "n";
      key = "]h";
      action.__raw = ''
function()
  if vim.wo.diff then return "]h" end
  vim.schedule(function() require("gitsigns").next_hunk() end)
end
'';
      options = { desc = "Next git hunk"; expr = true; silent = true; };
    }

    # Prev hunk
    {
      mode = "n";
      key = "[h";
      action.__raw = ''
function()
  if vim.wo.diff then return "[h" end
  vim.schedule(function() require("gitsigns").prev_hunk() end)
end
'';
      options = { desc = "Prev git hunk"; expr = true; silent = true; };
    }

    # Stage hunk
    {
      mode = "n";
      key = "<leader>ghs";
      action.__raw = ''function() require("gitsigns").stage_hunk() end'';
      options = { desc = "Stage hunk"; silent = true; };
    }

    # Reset hunk
    {
      mode = "n";
      key = "<leader>ghr";
      action.__raw = ''function() require("gitsigns").reset_hunk() end'';
      options = { desc = "Reset hunk"; silent = true; };
    }

    # Stage buffer
    {
      mode = "n";
      key = "<leader>ghS";
      action.__raw = ''function() require("gitsigns").stage_buffer() end'';
      options = { desc = "Stage buffer"; silent = true; };
    }

    # Reset buffer
    {
      mode = "n";
      key = "<leader>ghR";
      action.__raw = ''function() require("gitsigns").reset_buffer() end'';
      options = { desc = "Reset buffer"; silent = true; };
    }

    # Preview hunk
    {
      mode = "n";
      key = "<leader>ghp";
      action.__raw = ''function() require("gitsigns").preview_hunk() end'';
      options = { desc = "Preview hunk"; silent = true; };
    }

    # Blame line (full)
    {
      mode = "n";
      key = "<leader>ghb";
      action.__raw = ''
function()
  require("gitsigns").blame_line({ full = true })
end
'';
      options = { desc = "Blame line (full)"; silent = true; };
    }
  ];
}
