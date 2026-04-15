{
  plugins.neo-tree = {
    enable = true;
    settings.filesystem.follow_current_file.enabled = true;
  };

  # LSP-aware rename handler for Neo-tree using three-phase LSP protocol
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

        -- Use shared LSP rename function with proper three-phase protocol
        _G.lsp_rename_file(old_path, new_path, function()
          -- PHASE 2: Perform actual file operation
          vim.fn.rename(old_path, new_path)
        end)

        -- Refresh Neo-tree to show the renamed file
        vim.schedule(function()
          require("neo-tree.command").execute({ action = "refresh" })
          vim.notify("Renamed: " .. old_name .. " → " .. new_name, vim.log.levels.INFO)
        end)
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
