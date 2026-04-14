# nixvim

A standalone [Nixvim](https://github.com/nix-community/nixvim) configuration — Neovim configured entirely in Nix, built as a flake. Run with `nix run .` without installing anything globally.

## Project structure

```
.
├── flake.nix           # Flake inputs (nixpkgs-unstable, nixvim, flake-parts)
├── flake.lock
└── config/
    ├── default.nix                 # Entry point — imports all modules, sets globals.mapleader = " "
    ├── auto-save.nix               # Auto-save plugin (extraPlugin — not in nixvim)
    ├── blink-cmp.nix               # Autocompletion engine with LSP + auto-imports
    ├── catppuccin.nix              # Colorscheme
    ├── conform.nix                 # Code formatting (prettier, nixfmt)
    ├── dashboard.nix               # Startup dashboard (doom theme + quick actions)
    ├── fzf.nix                     # Fuzzy finder (fzf-lua) + keymaps
    ├── general-keymaps.nix         # General editor keybindings (clear search highlighting, etc.)
    ├── gitsigns.nix                # Git hunks visualization & keymaps
    ├── harpoon.nix                 # File navigation marks with fzf-lua picker
    ├── json-lsp.nix                # JSON language server with schema validation and sorting
    ├── json-sort-auto.nix          # Auto-sort JSON keys alphabetically on save
    ├── lint.nix                    # Code linting (statix, deadnix)
    ├── lsp.nix                     # Language servers (vue_ls, vtsls, eslint, nixd)
    ├── lsp-keymaps.nix             # LSP keybindings (code action, format, rename, diagnostics)
    ├── lualine.nix                 # Status line with catppuccin theme
    ├── neo-tree.nix                # File explorer with follow-current-file
    ├── neogit.nix                  # Git UI (Neogit)
    ├── noice.nix                   # UI overhaul (centered floating cmdline, messages, popupmenu)
    ├── persistence.nix             # Session save/restore with git branch tracking
    ├── spider.nix                  # Smart word motion respecting camelCase and snake_case
    ├── tailwindcss.nix             # Tailwind CSS LSP server configuration
    ├── telescope.nix               # Telescope fuzzy finder & fzf-native extension
    ├── tiny-inline-diagnostic.nix  # Inline diagnostics display (modern preset)
    ├── treesitter.nix              # Treesitter grammars, highlighting, indentation, folding
    ├── treesitter-textobjects.nix  # Treesitter textobject navigation (functions, classes, params)
    ├── ts-autotag.nix              # Auto-close HTML and JSX tags
    ├── vue-macros.nix              # Editor macros for Vue/TypeScript workflows
    ├── which-key.nix               # Keybinding hints and group labels
    └── yanky.nix                   # Yank history with system clipboard sync
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

### General Keybinds (general-keymaps.nix)

| Key | Action |
|---|---|
| `<Esc>` | Clear search highlighting |

### File explorer (Neo-tree)

| Key | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree (root dir) |
| `<leader>E` | Toggle Neo-tree (cwd) |
| `<leader>fe` | Focus Neo-tree (root dir) |
| `<leader>fE` | Focus Neo-tree (cwd) |

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

### Git (gitsigns)

| Key | Action |
|---|---|
| `<leader>]h` | Next git hunk |
| `<leader>[h` | Prev git hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line (full) |

### Yank history (yanky)

| Key | Action |
|---|---|
| `<leader>p` | Open Yank History (normal & visual) |

### Harpoon (harpoon.nix)

| Key | Action |
|---|---|
| `<leader>H` | Add current file to harpoon |
| `<leader>h` | Toggle harpoon quick menu |
| `<leader>1` | Jump to harpoon file 1 |
| `<leader>2` | Jump to harpoon file 2 |
| `<leader>3` | Jump to harpoon file 3 |
| `<leader>4` | Jump to harpoon file 4 |
| `<leader>5` | Jump to harpoon file 5 |
| `<leader>6` | Jump to harpoon file 6 |
| `<leader>7` | Jump to harpoon file 7 |
| `<leader>8` | Jump to harpoon file 8 |
| `<leader>9` | Jump to harpoon file 9 |
| `<leader>M` | Harpoon files with fzf-lua picker |

### Noice (noice.nix)

| Key | Action |
|---|---|
| `<leader>n` | Notification History (fzf-lua picker, copies to clipboard) |

### Which Key Hints (which-key)

Which-key registers leader-key groups to surface existing keybindings for discoverability (no new keybinds introduced). Notable hints:
- `<leader>e` / `<leader>E` / `<leader>fe` / `<leader>fE` — Neo-tree toggles and focus
- `<leader><space>` / `<leader>ff` / `<leader>fF` / `<leader>fg` / `<leader>fG` — fzf file/find/grep actions
- `<leader>gu` — Neogit
- `<leader>gh*` — gitsigns hunk actions (stage/reset/preview/blame)
- `<leader>n` — Notification history (Noice)
- `<leader>p` — Yank history (yanky.nvim)
- `<leader>H` / `<leader>h` / `<leader>1-9` — Harpoon file navigation
- `gd` — Go to definition (LSP)
- `gD` — Go to declaration (LSP)

### LSP keymaps (lsp-keymaps.nix)

| Key | Action |
|---|---|
| `<C-s>` | Save, format, and lint (normal & insert mode) |
| `<leader>ca` | Code Action (fzf-lua picker) |
| `<leader>cA` | Source Action (fzf-lua, fixAll/organizeImports) |
| `<leader>cF` | Apply fixAll (auto) |
| `<leader>cJ` | Sort JSON keys alphabetically |
| `<leader>cf` | Format buffer (Conform) |
| `<leader>cr` | Rename symbol |
| `<leader>cd` | Line diagnostics (float) |
| `<leader>xl` | Diagnostics → loclist |
| `]d` | Next diagnostic |
| `[d` | Prev diagnostic |
| `gd` | Go to definition (single result edits; multiple → fzf/quickfix) |
| `gD` | Go to declaration (same behaviour as `gd`) |
| `<leader>qq` | Quit all (`qa`) |

### Treesitter textobjects (treesitter-textobjects.nix)

| Key | Action |
|---|---|
| `]f` / `[f` | Next/Prev function start |
| `]F` / `[F` | Next/Prev function end |
| `]c` / `[c` | Next/Prev class start |
| `]C` / `[C` | Next/Prev class end |
| `]a` / `[a` | Next/Prev parameter start |
| `]A` / `[A` | Next/Prev parameter end |

Works in normal, visual, and operator-pending modes.

### Word Navigation (nvim-spider)

| Key | Action |
|---|---|
| `e` | Spider: End of word |
| `w` | Spider: Start of word |
| `b` | Spider: Back word |

Smart word motion respecting camelCase and snake_case boundaries. Works in normal, visual, and operator-pending modes.

### Session management (persistence.nvim)

| Key | Action |
|---|---|
| `<leader>qs` | Restore current session |
| `<leader>qS` | Select session to load |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |
| `s` (dashboard) | Restore last session (from dashboard) |

### Vue macros (vue-macros.nix)

| Key | Action |
|---|---|
| `<leader>ms` | Wrap StoreToRefs |
| `<leader>mc` | Wrap Composable |
| `<leader>mj` | Go To Definition Alias |
| `<leader>mp` | Props to Refs |
| `<leader>ma` | Destruct |

## Plugins

### general-keymaps (`config/general-keymaps.nix`)

General editor keybindings for common operations. Features:
- **Clear search highlighting**: Press `<Esc>` to turn off search highlighting after searching with `/`

### catppuccin (`config/catppuccin.nix`)

Colorscheme with dark/light variant support. Enabled via `colorschemes.catppuccin.enable = true`.

### lualine (`config/lualine.nix`)

Status line with catppuccin theme. Sections:
- `lualine_a`: vim mode
- `lualine_b`: git branch
- `lualine_c`: filename (with modified/readonly symbols)
- `lualine_x`: encoding, fileformat, filetype
- `lualine_y`: progress
- `lualine_z`: location

### dashboard (`config/dashboard.nix`)

Startup dashboard using the `doom` theme with large ASCII art header. Center actions for Find/Restore Session/Live Grep/New File/Git UI/Config/Quit. Footer shows loaded plugin stats. Actions call `fzf-lua` or builtins (e.g. `Neogit`, `enew`).

### noice (`config/noice.nix`)

UI overhaul that replaces the default Neovim UI with floating windows. Features:
- **Centered cmdline popup**: Floating command mode centered on screen with 60-char width
- **Message handling**: Notifications via `nvim-notify` with history tracking
- **Popupmenu**: NUI-powered completion popup
- **LSP integration**: Enhanced hover docs and signature help with proper rendering
- **Command palette**: Enabled via `command_palette` preset for better UX
- Commands: `:Noice` (history), `:Noice last` (last message), `:Noice dismiss` (clear messages)

### neo-tree (`config/neo-tree.nix`)

File explorer with automatic tracking of the current buffer. Provides keymaps to toggle/focus the tree for project root and current working directory (`<leader>e`, `<leader>E`, `<leader>fe`, `<leader>fE`).

### fzf-lua (`config/fzf.nix`)

Fast fuzzy finder for files and live grep with root-dir and cwd-aware variants. Keymaps: `<leader><space>`, `<leader>ff`, `<leader>fF` (files); `<leader>fg`, `<leader>fG` (grep); `<leader>/` (buffer grep).

### harpoon (`config/harpoon.nix`)

File navigation marks allowing quick jumps to frequently-used files. Provides 9 quick-access slots (`<leader>1-9`) and toggleable quick menu (`<leader>h`). Features fzf-lua integration for picker support via `<leader>M`. Keymaps: `<leader>H` to add file, `<leader>h` to toggle menu, `<leader>1-9` to jump, `<leader>M` for fzf picker.

### neogit (`config/neogit.nix`)

Git UI for interactive staging, commits, branching, and rebasing. Opened with `<leader>gu`.

### LSP (`config/lsp.nix`)

Five language servers configured:

| Server | Purpose |
|---|---|
| `vue_ls` | HTML/CSS sections of `.vue` files (hybrid mode) |
| `vtsls` | TypeScript/JavaScript + Vue via `@vue/typescript-plugin` |
| `eslint` | Linting for JS/TS/Vue/JSON |
| `nixd` | Semantic completions/diagnostics for `.nix` and flake files |
| `tailwindcss` | Tailwind CSS class completions and diagnostics |

Global `plugins.lsp.onAttach` disables semantic tokens for `vue_ls` to avoid volar crashes. `vtsls` is configured with `@vue/typescript-plugin`, TypeScript inlay hints, and auto-imports.

### json-lsp (`config/json-lsp.nix`)

JSON Language Server (jsonls) providing IntelliSense, schema validation, and comprehensive JSON support. Features:
- **Schema validation:** Auto-detects schemas for package.json, tsconfig.json, tailwind.config.json, etc.
- **IntelliSense:** Property autocomplete and descriptions
- **Validation:** Real-time error checking with schema-aware diagnostics
- **Sorting:** Integrates with LSP code actions for organizing/sorting JSON keys

### blink-cmp (`config/blink-cmp.nix`)

Modern Rust-based autocompletion engine with LSP-powered completions. Auto-imports from LSP servers (transparent to user). Features auto-brackets for function calls, documentation preview (200ms delay), and smart source prioritization (LSP → Buffer → Path). Keymap: `enter` accepts with auto-imports; `tab`/`shift-tab` navigate.

### conform (`config/conform.nix`)

Code formatter using Conform.nvim with format-on-save (500ms timeout). Supports:
- `prettier`: JavaScript, TypeScript, JSX, TSX, Vue, JSON, CSS, HTML
- `nixfmt`: Nix files
Falls back to LSP `textDocument/formatting` for unsupported filetypes.

### lint (`config/lint.nix`)

Code linter using Nvim-lint with automatic triggers (BufWritePost, BufReadPost, InsertLeave). Configured for Nix files:
- `statix`: Nix code linter
- `deadnix`: Detects dead code in Nix flakes

### auto-save (`config/auto-save.nix`)

[okuuva/auto-save.nvim](https://github.com/okuuva/auto-save.nvim) v1.1.0. Installed via `extraPlugins`. Automatically saves on `BufLeave` and `FocusLost` events while preserving undo/redo history.

### tiny-inline-diagnostic (`config/tiny-inline-diagnostic.nix`)

[rachartier/tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) displays inline error and warning messages with modern LazyVim-style preset. Shows source information and disables Neovim's default virtual text.

### telescope (`config/telescope.nix`)

Telescope fuzzy finder with fzf-native extension for fast sorting. Configured with horizontal layout, previews at 60% width. Integrates with fzf-lua for interactive picking.

### yanky (`config/yanky.nix`)

[yanky.nvim](https://github.com/gbprod/yanky.nvim) provides yank history with system clipboard sync. Mapping: `<leader>p` to open yank ring in normal and visual modes. `vim.opt.clipboard = "unnamedplus"` syncs yanks to system clipboard.

### lsp-keymaps (`config/lsp-keymaps.nix`)

LSP-focused keybindings: `<leader>ca` opens fzf-lua code action picker. `<leader>cA` filters source actions (fixAll, organizeImports). `<leader>cF` auto-applies fixAll. `<leader>cf` formats via `Conform`. `<leader>cr` renames. `<C-s>` (normal+insert) saves, formats, and shows notification. Definition/declaration lookups use fzf-lua for multiple results, inline edit for single result.

### vue-macros (`config/vue-macros.nix`)

Editor macros for Vue 3/TypeScript: storeToRefs wrapper, composable scaffolding, props-to-refs converter, destructuring helper, and go-to-definition alias. Exposed under `<leader>m*` keybindings.

### persistence.nvim (`config/persistence.nix`)

[folke/persistence.nvim](https://github.com/folke/persistence.nvim) provides automatic session save/restore. Sessions stored in `~/.local/state/nvim/sessions/` with optional git branch tracking. Saves only when more than 1 file is open. Four keybindings: restore current/select/restore last/don't save. Dashboard integration via `s` key.

### spider (`config/spider.nix`)

[chrisgrieser/nvim-spider](https://github.com/chrisgrieser/nvim-spider) provides smart word navigation that respects camelCase and snake_case boundaries. Replaces default `w`, `e`, `b` motions with context-aware variants in normal, visual, and operator-pending modes. Three keybindings: `w` (start of word), `e` (end of word), `b` (back word).

### treesitter (`config/treesitter.nix`)

Treesitter configuration with 33 language grammars for syntax highlighting, indentation, and code folding. Languages: bash, c, css, html, javascript, jsdoc, json, lua, nix, tsx, typescript, vim, diff, markdown, printf, query, regex, toml, xml, yaml, luadoc, luap, vimdoc, vue. Foldlevel set to 99 (all folds open by default).

### treesitter-textobjects (`config/treesitter-textobjects.nix`)

[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) provides code navigation via treesitter text objects. Eight keybindings jump to functions, classes, and parameters (start/end). Works in normal, visual, and operator-pending modes with auto-generated LazyVim-style descriptions.

### ts-autotag (`config/ts-autotag.nix`)

[windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) automatically closes HTML and JSX tags. Typing `<div>` followed by `>` auto-inserts the closing `</div>` tag based on treesitter parsing.

### Tailwind CSS (`config/tailwindcss.nix`)

LSP server for Tailwind CSS providing IntelliSense, class completions, color previews, and code actions. Configured for filetypes: `html`, `vue`, `jsx`, `tsx`, `css`. Features:
- **IntelliSense:** Autocomplete with descriptions
- **Color preview:** Inline color swatches
- **Code actions:** Quick fixes and suggestions
- **Diagnostics:** cssConflict, invalidApply, invalidScreen, etc.
- **Class sorting:** Delegated to prettier

### which-key (`config/which-key.nix`)

Keybinding hints showing leader-key groups and available actions for discoverability. Registers groups: `<leader>f` (Find), `<leader>g` (Git), `<leader>m` (Macros), `<leader>c` (LSP), `<leader>q` (Quit).

## Agent instructions

After completing any task in this project, **always run `/update-docs`** to keep `AGENTS.md` accurate. This includes:

the update-docs command is under .opencode/commands/update-docs.md

- Adding a new plugin or config file
- Changing a keybind
- Modifying LSP, formatter, or colorscheme config
- Any change to `config/default.nix`
