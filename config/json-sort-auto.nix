{ ... }:
{
  # Auto-sort JSON files alphabetically after save
  # Triggered by BufWritePost for all *.json and *.jsonc files
  autoGroups.JsonSort = {
    clear = true;
  };

  autoCmd = [
    {
      event = "BufWritePost";
      pattern = [ "*.json" "*.jsonc" ];
      group = "JsonSort";
      callback.__raw = ''function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        
        -- Only run on json/jsonc files
        if filetype ~= "json" and filetype ~= "jsonc" then
          return
        end
        
        -- Check if jsonls is attached to this buffer
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local has_jsonls = false
        for _, client in ipairs(clients) do
          if client.name == "jsonls" then
            has_jsonls = true
            break
          end
        end
        
        if not has_jsonls then
          return
        end
        
        -- Schedule sort after file write completes
        vim.schedule(function()
          local params = {
            command = "json.sort",
            arguments = { vim.uri_from_bufnr(bufnr) }
          }
          
          vim.lsp.buf_request_all(bufnr, "workspace/executeCommand", params, function(results)
            -- Check if any client successfully executed the command
            local success = false
            for client_id, result in pairs(results or {}) do
              if result and not result.err then
                success = true
                break
              end
            end
            
            if success then
              vim.notify("JSON sorted alphabetically", vim.log.levels.INFO)
            end
          end)
        end)
      end'';
    }
  ];
}
