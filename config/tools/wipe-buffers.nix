{ ... }:
{
  extraConfigLua = ''
    local function buffer_is_under_directory(buffer_handle, target_root, root_with_separator)
      local buffer_name = vim.api.nvim_buf_get_name(buffer_handle)
      if buffer_name == "" then
        return false
      end
      local full_path = vim.fn.fnamemodify(buffer_name, ":p")
      return vim.startswith(full_path, root_with_separator) or full_path == target_root
    end

    local function process_project_buffer(
      buffer_handle,
      target_root,
      root_with_separator,
      current_buffer,
      wiped_buffers,
      skipped_buffers
    )
      local buffer_name = vim.api.nvim_buf_get_name(buffer_handle)
      if not buffer_is_under_directory(buffer_handle, target_root, root_with_separator) then
        return
      end
      if vim.fn.getbufvar(buffer_handle, "&buftype") ~= "" then
        return
      end
      if buffer_handle == current_buffer then
        table.insert(skipped_buffers, buffer_name .. " (current)")
        return
      end
      if vim.fn.getbufvar(buffer_handle, "&modified") == 1 then
        table.insert(skipped_buffers, buffer_name .. " (unsaved changes)")
        return
      end
      if vim.fn.bufwinnr(buffer_handle) > 0 then
        table.insert(skipped_buffers, buffer_name .. " (visible in a window)")
        return
      end
      local delete_succeeded = pcall(vim.api.nvim_buf_delete, buffer_handle, { force = false })
      local target_list = delete_succeeded and wiped_buffers or skipped_buffers
      local report_entry = delete_succeeded and buffer_name or (buffer_name .. " (could not delete)")
      table.insert(target_list, report_entry)
    end

    local function wipe_buffers_under(directory)
      local target_root = vim.fn.fnamemodify(directory, ":p"):gsub("/+" .. "$", "")
      local root_with_separator = target_root .. "/"
      local current_buffer = vim.api.nvim_get_current_buf()
      local wiped_buffers = {}
      local skipped_buffers = {}
      for _, buffer_handle in ipairs(vim.api.nvim_list_bufs()) do
        process_project_buffer(
          buffer_handle,
          target_root,
          root_with_separator,
          current_buffer,
          wiped_buffers,
          skipped_buffers
        )
      end
      if #wiped_buffers > 0 then
        vim.notify("Wiped " .. #wiped_buffers .. " buffers", vim.log.levels.INFO)
      end
      if #skipped_buffers > 0 then
        vim.notify("Skipped: " .. table.concat(skipped_buffers, ", "), vim.log.levels.WARN)
      end
    end

    vim.api.nvim_create_user_command("WipeBuffersIn", function(command_options)
      local directory = command_options.args ~= "" and command_options.args or vim.fn.getcwd()
      wipe_buffers_under(directory)
    end, { nargs = "?" })
  '';
}
