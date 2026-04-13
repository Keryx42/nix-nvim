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
          -- Use custom LSP request 'json/sort' (not workspace/executeCommand)
          vim.lsp.buf_request(bufnr, "json/sort", {
            uri = vim.uri_from_bufnr(bufnr),
            options = {}
          }, function(err, result)
            if err then
              vim.notify("JSON sort failed: " .. err.message, vim.log.levels.ERROR)
              return
            end
            
            -- result is TextEdit[] that must be applied to buffer
            if result and #result > 0 then
              vim.lsp.util.apply_text_edits(result, bufnr, "utf-8")
              vim.notify("JSON sorted alphabetically", vim.log.levels.INFO)
            end
          end)
        end)
      end'';
    }
  ];
}
