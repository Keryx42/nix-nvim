# nixvim

A standalone [Nixvim](https://github.com/nix-community/nixvim) configuration — Neovim configured entirely in Nix, built as a flake. Run with `nix run .` without installing anything globally.

## Project structure

```
.
├── flake.nix           # Flake inputs (nixpkgs-unstable, nixvim, flake-parts)
├── flake.lock
└── config/
    ├── default.nix                 # Entry point — imports all modules, sets globals.mapleader = " "
    ├── auto-save.nix               # Auto-save (extraPlugin — not in nixvim)
    ├── blink-cmp.nix               # Autocompletion engine with LSP + auto-imports
    ├── catppuccin.nix              # Colorscheme
    ├── dashboard.nix               # Startup dashboard (doom theme + quick actions)
    ├── formatters.nix              # Formatters via none-ls
    ├── fzf.nix                     # Fuzzy finder (fzf-lua) + keymaps
    ├── gitsigns.nix                # Git hunks & keymaps (gitsigns.nvim)
    ├── lsp.nix                     # Language servers
    ├── lsp-keymaps.nix             # LSP keybindings (code action, format, rename, diagnostics)
    ├── lualine.nix                 # Status line
    ├── neo-tree.nix                # File explorer
    ├── neogit.nix                  # Git UI
    ├── persistence.nix             # Session save/restore with git branch tracking
    ├── telescope.nix               # Telescope fuzzy finder + code action picker
    ├── tiny-inline-diagnostic.nix  # Inline diagnostics (modern preset)
    ├── treesitter.nix              # Treesitter grammars, highlighting, indentation, folding
    ├── treesitter-textobjects.nix  # Treesitter textobject navigation (functions, classes, params)
    ├── ts-autotag.nix              # Auto-close HTML and JSX tags
    ├── vue-macros.nix              # Editor macros for Vue/TypeScript workflows
    ├── which-key.nix               # Keybinding hints
    └── yanky.nix                   # yanky.nvim (yank history) + mapping
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

### Git (gitsigns)

| Key | Action |
|---|---|
| `<leader>]h` | Next git hunk |
| `<leader>[h` | Prev git hunk |
| `<leader>ghs` | Stage current hunk |
| `<leader>ghr` | Reset current hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line (full) |

### Yank history (yanky)

| Key | Action |
|---|---|
| `<leader>p` | Open Yank History (normal & visual) |

### Which Key Hints (which-key)

Which-key registers leader-key groups to surface the existing keybindings for discoverability (no new keybinds introduced). Notable hints:
- `<leader>e` / `<leader>E` / `<leader>fe` / `<leader>fE` — Neo-tree toggles and focus
- `<leader><space>` / `<leader>ff` / `<leader>fF` / `<leader>fg` / `<leader>fG` — fzf file/find/grep actions
- `<leader>gu` — Neogit
- `<leader>gh*` — gitsigns hunk actions (stage/reset/preview/blame)
- `<leader>p` — Yank history (yanky.nvim)
- `gd` — Go to definition (LSP)
- `gD` — Go to declaration (LSP)

### LSP keymaps (lsp-keymaps.nix)

| Key | Action |
|---|---|
| `<leader>ca` | Code Action (fzf-lua picker) |
| `<leader>cA` | Source Action (fzf-lua, fixAll/organizeImports) |
| `<leader>cF` | Apply fixAll (auto) |
| `<leader>cf` | Format buffer (prefers `null-ls`) |
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

### catppuccin (`config/catppuccin.nix`)

Colorscheme. Enabled via `colorschemes.catppuccin.enable = true`.

### lualine (`config/lualine.nix`)

Status line with catppuccin theme. Sections:
- `lualine_a`: vim mode
- `lualine_b`: git branch
- `lualine_c`: filename (with modified/readonly symbols)
- `lualine_x`: encoding, fileformat, filetype
- `lualine_y`: progress
- `lualine_z`: location

### dashboard (`config/dashboard.nix`)

Startup dashboard using the `doom` theme: large ASCII header, center actions for Find/Recent/Grep/New/Neogit/Config/Quit, and a footer that reports loaded plugin stats. Center actions call `fzf-lua` or builtins (e.g. `Neogit`, `enew`).

### neo-tree (`config/neo-tree.nix`)

File explorer. `followCurrentFile` is enabled so the tree tracks the active buffer; provides mappings to toggle/focus the tree for project root and current buffer (`<leader>e`, `<leader>E`, `<leader>fe`, `<leader>fE`).

### fzf-lua (`config/fzf.nix`)

Fuzzy finder for files and live grep. Provides root-dir mappings via `plugins.fzf-lua.keymaps` and cwd-aware variants implemented as `keymaps` with `action.__raw` (e.g. `<leader>fF`, `<leader>fG`).

### neogit (`config/neogit.nix`)

Git UI opened with `<leader>gu`.

### LSP (`config/lsp.nix`)

Four servers configured for Vue/TypeScript and Nix projects:

| Server | Purpose |
|---|---|
| `vue_ls` | HTML/CSS sections of `.vue` files (hybrid mode) |
| `vtsls` | TypeScript/JavaScript + Vue via `@vue/typescript-plugin` (handles <script> / TS features) |
| `eslint` | Linting for JS/TS/Vue/JSON via `vscode-langservers-extracted` |
| `nixd` | Semantic completions/diagnostics for `.nix` + flake files |

Global `plugins.lsp.onAttach` includes a workaround that disables semantic tokens for `vue_ls`/volar to avoid known crashes. `vtsls` is configured with `@vue/typescript-plugin` wired to the nix store path of `pkgs.vue-language-server` and a set of TypeScript/JavaScript inlay/diagnostic preferences.

### blink-cmp (`config/blink-cmp.nix`)

Modern autocompletion engine powered by Rust with LSP-based completions. When accepting a completion that requires imports (e.g., `useRouter` from `vue-router`), the LSP server automatically includes the import statement via `additionalTextEdits`. This happens transparently—no extra steps needed.

**Keybindings (super-tab preset):**

| Key | Action |
|---|---|
| `<Tab>` | Next completion item / fallback insert |
| `<S-Tab>` | Previous completion item |
| `<Return>` | Accept selected completion (with auto-imports) |
| `<C-e>` | Cancel completion menu |
| `<C-Space>` | Manually trigger completion |

**Configuration highlights:**
- Auto-brackets for functions: `func()` style insertion
- Documentation auto-show with 200ms delay
- LSP capabilities auto-configured
- Sources: LSP (primary) → Buffer (fallback) → Path

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

### tiny-inline-diagnostic (`config/tiny-inline-diagnostic.nix`)

[rachartier/tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) provides styled inline error and warning messages. Configured with the `modern` preset (LazyVim-style) and displays source information. Disables Neovim's default virtual text to avoid conflicts.

### telescope (`config/telescope.nix`)

Fuzzy finder and Telescope plugin configuration. Configured with horizontal layout and fzf-native extension for faster sorting. Used by fzf-lua and other plugins for interactive picking.

### yanky (`config/yanky.nix`)

Enable `yanky.nvim` for an improved yank history and put behavior; provides a mapping `<leader>p` to open the yank ring in normal and visual modes. The config also sets `vim.opt.clipboard = "unnamedplus"` to sync yanks to the system clipboard.

### lsp-keymaps (`config/lsp-keymaps.nix`)

LSP-focused keybindings using fzf-lua picker: `<leader>ca` opens fzf-lua's LSP code action picker showing all available code actions from all LSP servers. `<leader>cA` shows only source actions (fixAll, organizeImports, etc.) filtered and displayed in fzf-lua picker. `<leader>cF` auto-applies fixAll without prompting. Also includes format buffer (prefers `null-ls`), rename, line diagnostics float, diagnostics → loclist, next/prev diagnostics, and LSP definition/declaration lookups that open a single result inline or fall back to `fzf-lua` / quickfix for multiple results.

### vue-macros (`config/vue-macros.nix`)

Editor macros tailored for Vue/TypeScript patterns (storeToRefs wrapper, composable scaffolding, props → refs, destruct helpers, go-to-definition alias) exposed under `<leader>m*` mappings.

### persistence.nvim (`config/persistence.nix`)

[folke/persistence.nvim](https://github.com/folke/persistence.nvim) provides automatic session save/restore functionality. Sessions are stored in `~/.local/state/nvim/sessions/` with optional git branch tracking. Configured to save only when more than 1 file is open. Provides four keybindings for session management: restore current, select, restore last, and don't save. Dashboard integration via `s` key to restore the last session.

## Agent instructions

After completing any task in this project, **always run `/update-docs`** to keep `AGENTS.md` accurate. This includes:

the update-docs command is under .opencode/commands/update-docs.md

- Adding a new plugin or config file
- Changing a keybind
- Modifying LSP, formatter, or colorscheme config
- Any change to `config/default.nix`

### treesitter (`config/treesitter.nix`)

Treesitter configuration for syntax highlighting, indentation, and code folding. Enables `nvim-treesitter` with 33 language grammars:
- **Web & Scripting:** bash, c, css, html, javascript, jsdoc, json, lua, nix, tsx, typescript, vim
- **Markup & Data:** diff, markdown, markdown_inline, printf, query, regex, toml, xml, yaml
- **Documentation:** luadoc, luap, vimdoc
- **Framework-specific:** vue

### treesitter-textobjects (`config/treesitter-textobjects.nix`)

[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) provides code navigation using treesitter text objects. Eight keybindings navigate functions, classes, and parameters with both start and end positions. Works in normal, visual, and operator-pending modes. Includes LazyVim-style auto-generated description hints.

### ts-autotag (`config/ts-autotag.nix`)

[windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) automatically closes HTML and JSX tags based on treesitter parsing. When you open a tag like `<div>`, pressing `>` automatically inserts the closing `</div>` tag.
