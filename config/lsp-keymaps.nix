{ pkgs, ... }:
{
  keymaps = [
    # Code action — all actions via fzf-lua picker
    {
      mode = ["n" "x"];
      key = "<leader>ca";
      action.__raw = ''function() require('fzf-lua').lsp_code_actions() end'';
      options = { desc = "Code Action"; silent = true; };
    }

    # Source actions — fixAll, organizeImports, etc. via fzf-lua picker with filtering
    {
      mode = ["n" "x"];
      key = "<leader>cA";
      action.__raw = ''function()
  require('fzf-lua').lsp_code_actions({
    filter = function(action)
      local kind = action.kind or ""
      return kind:match("^source") ~= nil
    end,
  })
end'';
      options = { desc = "Source Action"; silent = true; };
    }

    # Auto-apply fixAll without prompting
    {
      mode = "n";
      key = "<leader>cF";
      action.__raw = ''function()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.fixAll", "source.fixAll.eslint" } }
  
  vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, actions)
    if err or not actions or vim.tbl_isempty(actions) then
      vim.notify('No fixAll actions available', vim.log.levels.INFO)
      return
    end
    
    local act = actions[1]
    if act.edit then
      vim.lsp.util.apply_workspace_edit(act.edit, 'utf-8')
    end
    if act.command then
      vim.lsp.buf.execute_command(act.command)
    end
  end)
end'';
      options = { desc = "Apply fixAll (auto)"; silent = true; };
    }

    # Format buffer
    {
      mode = "n";
      key = "<leader>cf";
      action.__raw = ''function()
  -- Prefer null-ls (none-ls) as the formatter to ensure consistent formatting
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client and client.name == 'null-ls'
    end,
  })
end'';
      options = { desc = "Format buffer"; silent = true; };
    }

    # Rename
    {
      mode = "n";
      key = "<leader>cr";
      action.__raw = ''function() vim.lsp.buf.rename() end'';
      options = { desc = "Rename symbol"; silent = true; };
    }

    # Line diagnostics (float)
    {
      mode = "n";
      key = "<leader>cd";
      action.__raw = ''function() vim.diagnostic.open_float(nil, { scope = "line" }) end'';
      options = { desc = "Line diagnostics (float)"; silent = true; };
    }

    # Put diagnostics in loclist
    {
      mode = "n";
      key = "<leader>xl";
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

    # Go to definition with LSP; single result -> edit, multiple -> fzf-lua picker
    {
      mode = "n";
      key = "gd";
      action.__raw = ''
function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then return end

    local function get_uri_and_range(item)
      if item.uri then return item.uri, item.range end
      if item.targetUri then return item.targetUri, item.targetSelectionRange end
      return nil, nil
    end

    if vim.tbl_islist(result) and #result == 1 then
      local uri, range = get_uri_and_range(result[1])
      if uri then
        local fname = vim.uri_to_fname(uri)
        vim.cmd('edit ' .. vim.fn.fnameescape(fname))
        if range then vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character }) end
        return
      end
    end

    local ok, fzf = pcall(require, 'fzf-lua')
    if ok and fzf.lsp_definitions then
      fzf.lsp_definitions()
      return
    end

    local items = vim.lsp.util.locations_to_items(result)
    vim.fn.setqflist({}, ' ', { title = 'LSP Definitions', items = items })
    vim.cmd('copen')
  end)
end
'';
      options = { desc = "Go to definition (LSP + fzf-lua fallback)"; silent = true; };
    }

    # Quit all — matches LazyVim's <leader>qq
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options = { desc = "Quit All"; silent = true; };
    }

    # Save, format, and lint — works in normal and insert mode
    {
      mode = ["n" "i"];
      key = "<C-s>";
      action.__raw = ''function()
  -- Save the buffer
  vim.cmd.write()
  
  -- Format with none-ls (Prettier) asynchronously
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client and client.name == 'null-ls'
    end,
  })
  
  -- Show notification
  vim.notify('File saved and formatted', vim.log.levels.INFO)
end'';
      options = { desc = "Save, format, and lint"; silent = true; };
    }

    # Go to declaration with LSP; same behavior as gd
    {
      mode = "n";
      key = "gD";
      action.__raw = ''
function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/declaration", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then return end

    local function get_uri_and_range(item)
      if item.uri then return item.uri, item.range end
      if item.targetUri then return item.targetUri, item.targetSelectionRange end
      return nil, nil
    end

    if vim.tbl_islist(result) and #result == 1 then
      local uri, range = get_uri_and_range(result[1])
      if uri then
        local fname = vim.uri_to_fname(uri)
        vim.cmd('edit ' .. vim.fn.fnameescape(fname))
        if range then vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character }) end
        return
      end
    end

    local ok, fzf = pcall(require, 'fzf-lua')
    if ok and fzf.lsp_declarations then
      fzf.lsp_declarations()
      return
    end

    local items = vim.lsp.util.locations_to_items(result)
    vim.fn.setqflist({}, ' ', { title = 'LSP Declarations', items = items })
    vim.cmd('copen')
  end)
end
'';
      options = { desc = "Go to declaration (LSP + fzf-lua fallback)"; silent = true; };
    }
  ];
}
