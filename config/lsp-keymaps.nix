{ pkgs, ... }:
{
  keymaps = [
    # Code action (open code action menu)
    {
      mode = "n";
      key = "<leader>la";
      action.__raw = ''function() vim.lsp.buf.code_action() end'';
      options = { desc = "Code Action"; silent = true; };
    }

    # Try to apply source.fixAll (ESLint / fix-all actions) automatically if available
    {
      mode = "n";
      key = "<leader>lA";
      action.__raw = ''
function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.fixAll", "source.fixAll.eslint" } }

  vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, actions)
    if err or not actions or vim.tbl_isempty(actions) then
      -- Fallback: open code action menu
      vim.lsp.buf.code_action()
      return
    end

    -- Try to apply the first action that has an edit/command
    local act = actions[1]
    if act.edit then
      vim.lsp.util.apply_workspace_edit(act.edit)
    end
    if act.command then
      -- Some actions include a command to execute
      vim.lsp.buf.execute_command(act.command)
    end
  end)
end
'';
      options = { desc = "Apply fixAll (eslint if available)"; silent = true; };
    }

    # Format buffer
    {
      mode = "n";
      key = "<leader>lf";
      action.__raw = ''function() vim.lsp.buf.format({ async = true }) end'';
      options = { desc = "Format buffer"; silent = true; };
    }

    # Rename
    {
      mode = "n";
      key = "<leader>lr";
      action.__raw = ''function() vim.lsp.buf.rename() end'';
      options = { desc = "Rename symbol"; silent = true; };
    }

    # Line diagnostics (float)
    {
      mode = "n";
      key = "<leader>ld";
      action.__raw = ''function() vim.diagnostic.open_float(nil, { scope = "line" }) end'';
      options = { desc = "Line diagnostics (float)"; silent = true; };
    }

    # Put diagnostics in loclist
    {
      mode = "n";
      key = "<leader>lq";
      action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      options = { desc = "Diagnostics → loclist"; silent = true; };
    }

    # Next/previous diagnostic (normal mappings)
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      options = { desc = "Next diagnostic"; silent = true; };
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      options = { desc = "Prev diagnostic"; silent = true; };
    }
  ];
}
