{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "persistence-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "persistence.nvim";
        rev = "b20b2a7887bd39c1a356980b45e03250f3dce49c";
        hash = "sha256-ACuDEp4MNiP2X2LnsEjVWmajedXdCQ9gg/EK55YF7uM=";
      };
    })
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>qs";
      action.__raw = "function() require('persistence').load() end";
      options = { desc = "Restore current session"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>qS";
      action.__raw = "function() require('persistence').select() end";
      options = { desc = "Select session to load"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>ql";
      action.__raw = "function() require('persistence').load({ last = true }) end";
      options = { desc = "Restore last session"; silent = true; };
    }
    {
      mode = "n";
      key = "<leader>qd";
      action.__raw = "function() require('persistence').stop() end";
      options = { desc = "Don't save current session"; silent = true; };
    }
  ];

  extraConfigLua = ''
    local function normalize_buffer_names()
      for _, buffer_handle in ipairs(vim.api.nvim_list_bufs()) do
        local buffer_name = vim.api.nvim_buf_get_name(buffer_handle)
        if buffer_name ~= "" then
          local clean_name = buffer_name:gsub("^%./", ""):gsub("/%./", "/")
          if clean_name ~= buffer_name then
            pcall(vim.api.nvim_buf_set_name, buffer_handle, clean_name)
          end
        end
      end
    end

    require("persistence").setup({
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
      pre_save = normalize_buffer_names,
      post_restore = normalize_buffer_names,
    })
  '';
}
