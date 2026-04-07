{ pkgs, ... }:
{
  # nvim-treesitter-textobjects provides code navigation using treesitter text objects
  # Keybinds allow jumping to functions, classes, and parameters with start/end positions
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-treesitter-textobjects";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-treesitter";
        repo = "nvim-treesitter-textobjects";
        rev = "851e865342e5a4cb1ae23d31caf6e991e1c99f1e";
        hash = "sha256-fOpRElIwvsFWm4AwETx7fpC3RtdH2BpCfX4YHVitqw0=";
      };
    })
  ];

  extraConfigLua = ''
    -- Setup treesitter-textobjects with LazyVim-style keybinding generation
    require("nvim-treesitter-textobjects").setup({
      move = {
        enable = true,
        set_jumps = true, -- set jumps in the jumplist
      },
    })

    -- Define movement keybinds with their text object targets
    local moves = {
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]A"] = "@parameter.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[A"] = "@parameter.inner",
      },
    }

    -- Attach keymaps to a buffer with auto-generated descriptions
    local function attach(buf)
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          -- Extract text object name from query (e.g., "@function.outer" -> "function")
          local part = query:gsub("@", ""):gsub("%..*", "")
          -- Capitalize first letter
          part = part:sub(1, 1):upper() .. part:sub(2)

          -- Build description: "Next Function Start", "Prev Class End", etc.
          local desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. part
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

          vim.keymap.set({ "n", "x", "o" }, key, function()
            -- Handle diff mode: allow normal [c/]c for diff navigation
            if vim.wo.diff and key:find("[cC]") then
              return vim.cmd("normal! " .. key)
            end
            require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
          end, {
            buffer = buf,
            desc = desc,
            silent = true,
          })
        end
      end
    end

    -- Create autocmd to attach keymaps to buffers on FileType
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("nixvim_treesitter_textobjects", { clear = true }),
      callback = function(ev)
        attach(ev.buf)
      end,
    })

    -- Attach to all currently open buffers
    vim.tbl_map(attach, vim.api.nvim_list_bufs())
  '';
}
