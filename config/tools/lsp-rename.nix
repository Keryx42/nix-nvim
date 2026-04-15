{ pkgs, ... }:
{
  # Shared LSP utilities for rename operations
  extraConfigLua = ''
    -- Three-phase LSP file rename protocol
    -- Phase 1: workspace/willRenameFiles (pre-rename edits)
    -- Phase 2: Actual file operation
    -- Phase 3: workspace/didRenameFiles (post-rename notification)
    _G.lsp_rename_file = function(old_path, new_path, on_complete)
      if not old_path or not new_path then
        return
      end

      local old_uri = vim.uri_from_fname(old_path)
      local new_uri = vim.uri_from_fname(new_path)

      local changes = {
        files = {
          {
            oldUri = old_uri,
            newUri = new_uri,
          }
        }
      }

      -- Get all active LSP clients
      local clients = vim.lsp.get_active_clients()

      -- PHASE 1: Pre-rename coordination
      for _, client in ipairs(clients) do
        if client.supports_method("workspace/willRenameFiles") then
          local resp = client.request_sync("workspace/willRenameFiles", changes, 1000)
          if resp and resp.result then
            -- Apply workspace edits (import updates, reference changes, etc.)
            vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
          end
        end
      end

      -- PHASE 2: Perform actual file operation
      if on_complete then
        on_complete()
      end

      -- PHASE 3: Post-rename notification
      for _, client in ipairs(clients) do
        if client.supports_method("workspace/didRenameFiles") then
          client.notify("workspace/didRenameFiles", changes)
        end
      end
    end
  '';
}
