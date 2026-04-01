# nixvim

A standalone [Nixvim](https://github.com/nix-community/nixvim) configuration — Neovim configured entirely in Nix, built as a flake. Run with `nix run .` without installing anything globally.

## Project structure

```
.
├── flake.nix           # Flake inputs (nixpkgs-unstable, nixvim, flake-parts)
├── flake.lock
└── config/
    ├── default.nix     # Entry point — imports all modules, sets globals.mapleader = " "
    ├── catppuccin.nix  # Colorscheme
    ├── bufferline.nix  # Tab bar + web-devicons
    ├── lualine.nix     # Status line
    ├── neo-tree.nix    # File explorer
    ├── fzf.nix         # Fuzzy finder
    ├── neogit.nix      # Git UI
    ├── treesitter.nix  # Treesitter grammars & settings
    ├── lsp.nix         # Language servers
    ├── formatters.nix  # Formatters via none-ls
    ├── which-key.nix   # Keybinding hints
    └── auto-save.nix   # Auto-save (extraPlugin — not in nixvim)
```

Each plugin lives in its own file and is imported in `config/default.nix`.

## How to add a plugin

1. Create `config/<plugin>.nix`
2. Add `./config/<plugin>.nix` to the `imports` list in `config/default.nix`
3. Use `plugins.<name>.enable = true` for nixvim-managed plugins
4. For plugins not in nixvim, use `extraPlugins` + `extraConfigLua` (see `auto-save.nix`)

## Running / testing

```bash
nix run --extra-experimental-features "nix-command flakes" .
nix flake check --extra-experimental-features "nix-command flakes" .
```

## Keybinds

Leader key: `<Space>`

### File explorer (Neo-tree)

| Key | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree (root dir) |
| `<leader>E` | Toggle Neo-tree (cwd) |
| `<leader>fe` | Focus/reveal Neo-tree (root dir) |
| `<leader>fE` | Focus/reveal Neo-tree (cwd) |

### Fuzzy finder (fzf-lua)

| Key | Action |
|---|---|
| `<leader><space>` | Find files (root dir) |
| `<leader>ff` | Find files (root dir) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fg` | Live grep (root dir) |
| `<leader>sg` | Live grep (root dir) |
| `<leader>fG` | Live grep (cwd) |
| `<leader>/` | Grep current buffer |

### Git (Neogit)

| Key | Action |
|---|---|
| `<leader>gu` | Open Neogit |

### Which Key Hints (which-key)

Which-key registers leader-key groups to surface the existing keybindings for discoverability (no new keybinds introduced). Notable hints:
- `<leader>e` / `<leader>E` / `<leader>fe` / `<leader>fE` — Neo-tree toggles and focus
- `<leader><space>` / `<leader>ff` / `<leader>fF` / `<leader>fg` / `<leader>fG` — fzf file/find/grep actions
- `<leader>gu` — Neogit

## Plugins

### catppuccin (`config/catppuccin.nix`)

Colorscheme. Enabled via `colorschemes.catppuccin.enable = true`.

### bufferline (`config/bufferline.nix`)

Tab bar for open buffers. Also enables `web-devicons` for file-type icons used across all plugins.

### lualine (`config/lualine.nix`)

Status line with catppuccin theme. Sections:
- `lualine_a`: vim mode
- `lualine_b`: git branch
- `lualine_c`: filename (with modified/readonly symbols)
- `lualine_x`: encoding, fileformat, filetype
- `lualine_y`: progress
- `lualine_z`: location

### neo-tree (`config/neo-tree.nix`)

File explorer. `followCurrentFile` is enabled so the tree tracks the active buffer.

### fzf-lua (`config/fzf.nix`)

Fuzzy finder for files and live grep. Root-dir variants use built-in `keymaps`, cwd variants use `keymaps` with `action.__raw` (Lua function).

### neogit (`config/neogit.nix`)

Git UI opened with `<leader>gu`.

### LSP (`config/lsp.nix`)

Four servers configured for Vue/TypeScript and Nix projects:

| Server | Purpose |
|---|---|
| `vue_ls` | HTML/CSS sections of `.vue` files (hybrid mode) |
| `vtsls` | TypeScript/JavaScript + Vue via `@vue/typescript-plugin` |
| `eslint` | Linting for JS/TS/Vue/JSON via `vscode-langservers-extracted` |
| `nixd` | Semantic completions/diagnostics for `.nix` + flake files |

`vtsls` has `@vue/typescript-plugin` wired to the nix store path of `pkgs.vue-language-server` so no manual path resolution is needed.

### formatters (`config/formatters.nix`)

`none-ls` is used to run formatter/diagnostic sources. Currently configured:

| Source | Type |
|---|---|
| `prettier` | formatter (`pkgs.nodePackages.prettier`) |
| `nixfmt` | formatter for `.nix` files |
| `statix` | diagnostics for Nix projects |
| `deadnix` | diagnostics for dead code in Nix flake graphs |

### auto-save (`config/auto-save.nix`)

[okuuva/auto-save.nvim](https://github.com/okuuva/auto-save.nvim) v1.1.0. Not in nixvim's plugin set, so installed via `extraPlugins` + `buildVimPlugin`. Saves on `BufLeave` and `FocusLost`. `noautocmd = false` to preserve undo/redo history.

## Agent instructions

After completing any task in this project, **always run `/update-docs`** to keep `AGENTS.md` accurate. This includes:

- Adding a new plugin or config file
- Changing a keybind
- Modifying LSP, formatter, or colorscheme config
- Any change to `config/default.nix`

### treesitter (`config/treesitter.nix`)

Treesitter configuration for syntax highlighting and indentation. The file enables `nvim-treesitter` and includes grammars for `vue`, `typescript`, `javascript`, `tsx`, `css`, `html`, `json`, `jsdoc`, `lua`, `bash`, and `nix`.
