{ pkgs, ... }:
{
  # nvim-treesitter-textobjects provides syntax-aware text objects for:
  # - move: jump between functions, classes, and parameters
  # - select: visual/operator-pending selections (af/if, ac/ic, aa/ia)
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
    -- Setup treesitter-textobjects with move and select modes
    require("nvim-treesitter-textobjects").setup({
      move = {
        enable = true,
        set_jumps = true, -- set jumps in the jumplist
      },
      select = {
        enable = true,
        lookahead = true, -- automatically jump forward to textobject
        selection_modes = {
          ["@function.outer"] = "V", -- linewise
          ["@function.inner"] = "V",
          ["@class.outer"] = "V",
          ["@class.inner"] = "V",
          ["@parameter.outer"] = "v", -- charwise
          ["@parameter.inner"] = "v",
        },
      },
    })

    -- Define configuration for move and select modes
    local opts = {
      move = {
        enable = true,
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
    }

    -- Helper function to extract and format text object name
    local function format_textobject_name(query)
      local part = query:gsub("@", ""):gsub("%..*", "")
      return part:sub(1, 1):upper() .. part:sub(2)
    end

    -- Attach keymaps to a buffer with auto-generated descriptions
    local function attach(buf)
      -- Attach move keybinds
      if vim.tbl_get(opts, "move", "enable") then
        local moves = vim.tbl_get(opts, "move", "keys") or {}
        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              table.insert(parts, format_textobject_name(q))
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
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

      -- Attach select keybinds
      if vim.tbl_get(opts, "select", "enable") then
        local selects = vim.tbl_get(opts, "select", "keymaps") or {}
        for key, query in pairs(selects) do
          local is_inner = key:sub(2) == key:sub(2):lower()
          local textobj_name = format_textobject_name(query)
          local desc = (is_inner and "Select Inside " or "Select Around ") .. textobj_name

          vim.keymap.set({ "x", "o" }, key, function()
            require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
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
