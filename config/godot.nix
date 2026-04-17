{ pkgs, ... }:
{
  # godotdev.nvim: Comprehensive Godot 4 development plugin for Neovim
  # Provides: GDScript LSP, GDShader support, DAP debugging, formatting, auto-detection
  # Reference: https://github.com/Mathijs-Bakker/godotdev.nvim

  # Install godotdev.nvim plugin
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "godotdev.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Mathijs-Bakker";
        repo = "godotdev.nvim";
        rev = "e2a6eec848031087657549f3adb94d214fd2d2c0"; # Latest stable (2026-04-14)
        hash = "sha256-yXecSQqklKprnBqViryWJjGRruQBLlvjdH9k8HrCpFk=";
      };
    })
  ];

  extraConfigLua = ''
    -- Setup godotdev.nvim with automatic Godot project detection
    require("godotdev").setup({
      -- LSP server connection (Godot editor settings: Network > Language Server)
      editor_host = "127.0.0.1",
      editor_port = 6005,
      debug_port = 6006,

      -- Auto-start editor server on plugin setup (optional: set to true if desired)
      autostart_editor_server = false,

      -- Formatter for GDScript files
      formatter = "gdscript-formatter", -- or "gdformat" | false to disable
      formatter_cmd = { "gdscript-formatter", "--reorder-code" },

      -- TreeSitter setup for GDShader syntax highlighting
      treesitter = {
        auto_setup = true,
        ensure_installed = { "gdscript", "gdshader" },
      },

      -- Godot documentation display settings
      docs = {
        renderer = "float",            -- Display in floating window
        fallback_renderer = "browser", -- Fallback to browser if fetch fails
        version = "stable",            -- Godot docs version
        language = "en",
      },
    })

    -- Auto-detection notification: only notify if server connects successfully
    -- This hook fires after LSP client attaches to a gdscript/gdshader buffer
    local function on_attach(_, bufnr)
      -- Notification is only shown when LSP successfully connects
      vim.notify("Godot LSP connected", vim.log.levels.INFO, { title = "godotdev.nvim" })
    end

    -- Register attach hook for gdscript files only on first successful connection
    local group = vim.api.nvim_create_augroup("nixvim_godot_notify", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and (client.name == "gdscript" or client.name:match("godot")) then
          -- Only notify once per buffer
          if not vim.b[args.buf].godot_lsp_notified then
            on_attach(client, args.buf)
            vim.b[args.buf].godot_lsp_notified = true
          end
        end
      end,
    })
  '';
}
