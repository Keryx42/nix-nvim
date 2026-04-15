{
  plugins.neo-tree = {
    enable = true;
    settings.filesystem.follow_current_file.enabled = true;
  };

  # LSP-aware rename handler for Neo-tree
  # Attempts LSP rename (with temp file opening if needed), falls back to filesystem rename
  extraConfigLua = ''
    local function lsp_aware_rename(state)
      local node = state.tree:get_node()
      if not node then return end

      local old_path = node:get_id()
      local old_name = vim.fn.fnamemodify(old_path, ':t')

      -- Prompt for new name
      vim.ui.input({ prompt = "Rename to: ", default = old_name }, function(new_name)
        if not new_name or new_name == "" or new_name == old_name then
          return
        end

        local dir = vim.fn.fnamemodify(old_path, ':h')
        local new_path = dir .. "/" .. new_name
        local new_name_symbol = vim.fn.fnamemodify(new_name, ':r') -- Remove extension

        -- Check if file is already open
        local bufnr = vim.fn.bufloaded(old_path) == 1 and vim.fn.bufnr(old_path) or -1
        local was_open = bufnr ~= -1

        -- If not open, open it temporarily
        if not was_open then
          vim.cmd("silent noautocmd edit " .. vim.fn.fnameescape(old_path))
          bufnr = vim.api.nvim_get_current_buf()
        end

        -- Get active LSP clients for this buffer
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

        if #clients > 0 then
          -- LSP rename available: prepare parameters
          local params = vim.lsp.util.make_position_params(0, clients[1].offset_encoding)

          -- Attempt LSP rename for all references
          vim.lsp.buf_request(bufnr, "textDocument/rename", {
            textDocument = { uri = vim.uri_from_bufnr(bufnr) },
            position = params.position,
            newName = new_name_symbol,
          }, function(err, result)
            if err then
              -- LSP rename failed, fall back to filesystem rename
              vim.notify("LSP rename failed, using filesystem rename", vim.log.levels.WARN)
              vim.fn.rename(old_path, new_path)
            elseif result then
              -- LSP rename succeeded, apply workspace edit
              vim.lsp.util.apply_workspace_edit(result, "utf-8")
              vim.notify("Renamed with LSP (all references updated)", vim.log.levels.INFO)
              
              -- Also rename the file on disk
              vim.fn.rename(old_path, new_path)
            end

            -- If we opened the file, close it after rename
            if not was_open then
              vim.cmd("silent bdelete! " .. bufnr)
            end

            -- Refresh Neo-tree to show the renamed file
            vim.schedule(function()
              require("neo-tree.command").execute({ action = "refresh" })
            end)
          end)
        else
          -- No LSP available, use filesystem rename
          vim.fn.rename(old_path, new_path)
          vim.notify("Renamed (filesystem only, no LSP available)", vim.log.levels.INFO)

          -- Close temp buffer if we opened it
          if not was_open then
            vim.cmd("silent bdelete! " .. bufnr)
          end

          -- Refresh Neo-tree to show the renamed file
          require("neo-tree.command").execute({ action = "refresh" })
        end
      end)
    end

    -- Setup Neo-tree keymap for LSP-aware rename
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function(event)
        vim.keymap.set("n", "r", function()
          lsp_aware_rename(require("neo-tree.utils").get_state(event.buf))
        end, { buffer = event.buf, noremap = true, silent = true })
      end,
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle reveal<cr>";
      options = {
        desc = "Toggle Neo-tree (root dir)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action.__raw = "function() vim.cmd('Neotree toggle reveal dir=' .. vim.fn.expand('%:p:h')) end";
      options = {
        desc = "Toggle Neo-tree (cwd)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Neotree reveal<cr>";
      options = {
        desc = "Focus Neo-tree (root dir)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fE";
      action.__raw = "function() vim.cmd('Neotree reveal dir=' .. vim.fn.expand('%:p:h')) end";
      options = {
        desc = "Focus Neo-tree (cwd)";
        silent = true;
      };
    }
  ];
}
