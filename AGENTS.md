# nixvim

A standalone [Nixvim](https://github.com/nix-community/nixvim) configuration — Neovim configured entirely in Nix, built as a flake. Run with `nix run .` without installing anything globally.

## Project structure

```
.
├── flake.nix           # Flake inputs (nixpkgs-unstable, nixvim, flake-parts)
├── flake.lock
└── config/
     ├── default.nix                 # Entry point — imports modules and sets globals.mapleader = " "
     ├── auto-save.nix               # Auto-save.nvim via extraPlugins + extraConfigLua
     ├── blink-cmp.nix               # Blink-powered completion (LSP, auto-imports, smart sources)
     ├── catppuccin.nix              # Catppuccin colorscheme configuration
     ├── clipboard.nix               # Clipboard providers (pbcopy, xclip, wl-copy) multi-platform config
     ├── conform.nix                 # Conform.nvim formatter configuration (prettier, nixfmt)
     ├── dashboard.nix               # Startup dashboard (doom header, quick actions)
     ├── fzf.nix                     # fzf-lua integration and global keymaps
     ├── general-keymaps.nix         # Global non-LSP keybindings (e.g. Esc nohl)
     ├── godot.nix                   # Godot 4 development (godotdev.nvim LSP, GDShader, DAP, docs)
     ├── gitsigns.nix                # Git hunk signs and gitsigns keymaps
     ├── harpoon.nix                 # Harpoon marks + fzf picker + keymaps
      ├── lualine.nix                 # Lualine statusline configured with theme
      ├── mini-pairs.nix              # mini.pairs automatic bracket/quote pairing
      ├── neo-tree.nix                # Neo-tree explorer + LSP-aware rename handler
     ├── neogit.nix                  # Neogit Git UI integration
     ├── noice.nix                   # Noice UI (centered cmdline, notifications, popupmenu)
     ├── persistence.nix             # persistence.nvim session save/restore
     ├── spider.nix                  # nvim-spider word motions (camelCase/snakes)
     ├── tailwindcss.nix             # Tailwind CSS LSP server and settings
     ├── telescope.nix               # Telescope + fzf-native configuration
     ├── terminal-title.nix          # Terminal title updates (folder + Nixvim)
     ├── tiny-inline-diagnostic.nix  # Inline diagnostics (tiny-inline-diagnostic.nvim)
     ├── treesitter.nix              # Treesitter grammars and core settings
     ├── treesitter-textobjects.nix  # Treesitter textobjects and keymaps
     ├── ts-autotag.nix              # nvim-ts-autotag for closing HTML/JSX tags
     ├── vue-macros.nix              # Vue/TS editor macros and helper keymaps
     ├── which-key.nix                # Which-key groups and descriptions
     ├── windows.nix                  # Window/split management (LazyVim-style)
     ├── yanky.nix                   # Yank history (yanky.nvim) with clipboard integration
    ├── languages/
    │   ├── _shared.nix             # Shared LSP hooks and utilities
    │   ├── web.nix                 # Web languages: vtsls, vue_ls, eslint, prettier
    │   ├── nix.nix                 # Nix language: nixd + nixfmt
    │   ├── json.nix                # JSON: jsonls + schemas + prettier
    │   ├── markdown.nix            # Markdown: marksman + prettier
    │   └── python.nix              # Python: pyright + black + ruff
    └── tools/
        ├── linting.nix             # Linter integration (statix, deadnix, ruff)
        ├── lsp-rename.nix          # Three-phase LSP file rename helper (_G.lsp_rename_file)
        ├── lsp-keymaps.nix         # LSP-focused keymaps and helper commands
        └── json-sort-auto.nix      # JSON sort command and autocmds
```

Core editor features and plugins live at the repo root `config/`. Language support is unified under `config/languages/` (each file declares TreeSitter/LSP/formatters). Cross-cutting utilities live under `config/tools/`.

## How to add a plugin or language

**For a new editor plugin:**
1. Create `config/<plugin>.nix`
2. Add `./config/<plugin>.nix` to the `imports` list in `config/default.nix`
3. Use `plugins.<name>.enable = true` for nixvim-managed plugins
4. For plugins not in nixvim, use `extraPlugins` + `extraConfigLua` (see `auto-save.nix`)

**For a new language:**
1. Create `config/languages/<language>.nix` with LSP servers and formatter config
2. Add `./languages/<language>.nix` to the `imports` list in `config/default.nix`
3. Add TreeSitter grammar to `grammarPackages` in `config/treesitter.nix`

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
| `r` (in Neo-tree) | Rename file with LSP support (updates all references) |

### Fuzzy finder (fzf-lua)

| Key | Action |
|---|---|
| `<leader><space>` | Find files (root dir) |
| `<leader>ff` | Find files (root dir) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fg` | Live grep (root dir) |
| `<leader>sg` | Live grep (root dir) |
| `<leader>sm` | Search modified files |
| `<leader>fG` | Live grep (cwd) |
| `<leader>/` | Grep current buffer |

### Completion (blink-cmp)

| Key | Action |
|---|---|
| `<Enter>` | Accept completion (with auto-imports) |
| `<Tab>` / `<S-Tab>` | Navigate completion items |

### Git (Neogit)

| Key | Action |
|---|---|
| `<leader>gu` | Open Neogit |

### Git (gitsigns)

| Key | Action |
|---|---|
| `]h` | Next git hunk |
| `[h` | Prev git hunk |
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

### Startup dashboard (dashboard.nix)

| Key | Action |
|---|---|
| `s` | Restore last session (dashboard center action) |
| `g` | Live Grep (dashboard center action) |
| `n` | New File (dashboard center action) |
| `u` | Open Neogit (dashboard center action) |
| `c` | Open config files (fzf-lua) |
| `q` | Quit (dashboard center action) |

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
| `<leader>cR` | Rename file (with LSP updates for all references) |
| `<leader>cd` | Line diagnostics (float) |
| `<leader>xl` | Diagnostics → loclist |
| `]d` | Next diagnostic |
| `[d` | Prev diagnostic |
| `gd` | Go to definition (single result edits; multiple → fzf/quickfix) |
| `gD` | Go to declaration (same behaviour as `gd`) |
| `<leader>qq` | Quit all (`qa`) |

### Treesitter textobjects (treesitter-textobjects.nix)

#### Move (Navigation)

| Key | Action |
|---|---|
| `]f` / `[f` | Next/Prev function start |
| `]F` / `[F` | Next/Prev function end |
| `]c` / `[c` | Next/Prev class start |
| `]C` / `[C` | Next/Prev class end |
| `]a` / `[a` | Next/Prev parameter start |
| `]A` / `[A` | Next/Prev parameter end |

Works in normal, visual, and operator-pending modes.

#### Select (Text Objects)

| Key | Action |
|---|---|
| `af` / `if` | Around/Inside function |
| `ac` / `ic` | Around/Inside class |
| `aa` / `ia` | Around/Inside parameter |

Works in visual and operator-pending modes with automatic lookahead. Examples:
- `vif` - Select inside function (visual mode)
- `daf` - Delete around function
- `cic` - Change inside class

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

### clipboard (`config/clipboard.nix`)

Declarative clipboard provider configuration for multi-platform support using nixvim's clipboard module:
- **macOS/Darwin:** `pbcopy`/`pbpaste` (native OS clipboard)
- **Linux X11:** `xclip` (explicit Nix package)
- **Linux Wayland:** `wl-copy`/`wl-paste` (explicit Nix package)

Providers are installed but global clipboard sync (`vim.opt.clipboard = "unnamedplus"`) is handled conditionally in `yanky.nix` to prevent freezes on systems without proper clipboard support.

### lualine (`config/lualine.nix`)

Status line with catppuccin theme. Sections:
- `lualine_a`: vim mode
- `lualine_b`: git branch
- `lualine_c`: filename (with modified/readonly symbols)
- `lualine_x`: encoding, fileformat, filetype
- `lualine_y`: progress
- `lualine_z`: location

### mini-pairs (`config/mini-pairs.nix`)

[mini.pairs](https://github.com/nvim-mini/mini.pairs) provides automatic bracket and quote pairing. Features:
- **Auto-pairing:** Pairs `()`, `[]`, `{}`, `""`, `''`, `` ` ``
- **Smart closing:** Automatically inserts closing bracket/quote
- **Context-aware:** Respects surrounding context to avoid pairing in inappropriate places
- Works automatically with no configuration needed

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

File explorer with automatic tracking of the current buffer. Provides keymaps to toggle/focus the tree for project root and current working directory (`<leader>e`, `<leader>E`, `<leader>fe`, `<leader>fE`). LSP-aware rename with `r` in Neo-tree or `<leader>cR` from any buffer—uses three-phase LSP protocol (workspace/willRenameFiles → file move → workspace/didRenameFiles) to automatically update all references across the codebase when LSP is available. Coordinates multiple LSP clients simultaneously (e.g., vtsls + vue_ls for .vue files).

### fzf-lua (`config/fzf.nix`)

Fast fuzzy finder for files and live grep with root-dir and cwd-aware variants. Keymaps: `<leader><space>`, `<leader>ff`, `<leader>fF` (files); `<leader>fg`, `<leader>fG` (grep); `<leader>/` (buffer grep).

### harpoon (`config/harpoon.nix`)

File navigation marks allowing quick jumps to frequently-used files. Provides 9 quick-access slots (`<leader>1-9`) and toggleable quick menu (`<leader>h`). Features fzf-lua integration for picker support via `<leader>M`. Keymaps: `<leader>H` to add file, `<leader>h` to toggle menu, `<leader>1-9` to jump, `<leader>M` for fzf picker.

### neogit (`config/neogit.nix`)

Git UI for interactive staging, commits, branching, and rebasing. Opened with `<leader>gu`.

### gitsigns (`config/gitsigns.nix`)

Git hunk signs and utilities: next/prev hunk (`]h`/`[h`), stage/reset hunk, stage/reset buffer, preview hunk, and blame line. Keymaps under `<leader>gh*` for hunk actions.

### Languages and LSP

Language support is organized in `config/languages/` with each language file containing TreeSitter grammar references, LSP server configurations, and formatter setup. TreeSitter grammars are centrally managed in `config/treesitter.nix`.

### blink-cmp (`config/blink-cmp.nix`)

Modern Rust-based autocompletion engine with LSP-powered completions. Auto-imports from LSP servers (transparent to user). Features auto-brackets for function calls, documentation preview (200ms delay), and smart source prioritization (LSP → Buffer → Path). Keymap: `enter` accepts with auto-imports; `tab`/`shift-tab` navigate.

### conform (`config/conform.nix`)

Code formatter using Conform.nvim with format-on-save (500ms timeout). Supports:
- `prettier`: JavaScript, TypeScript, JSX, TSX, Vue, JSON, CSS, HTML, Markdown
- `nixfmt`: Nix files
Falls back to LSP `textDocument/formatting` for unsupported filetypes.

### auto-save (`config/auto-save.nix`)

[okuuva/auto-save.nvim](https://github.com/okuuva/auto-save.nvim) v1.1.0. Installed via `extraPlugins`. Automatically saves on `BufLeave` and `FocusLost` events while preserving undo/redo history.

### tiny-inline-diagnostic (`config/tiny-inline-diagnostic.nix`)

[rachartier/tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) displays inline error and warning messages with modern LazyVim-style preset. Shows source information and disables Neovim's default virtual text.

### telescope (`config/telescope.nix`)

Telescope fuzzy finder with fzf-native extension for fast sorting. Configured with horizontal layout, previews at 60% width. Integrates with fzf-lua for interactive picking.

### terminal-title (`config/terminal-title.nix`)

Sets Ghostty terminal window title to current folder name with "Nixvim" suffix (e.g., `nixvim - Nixvim`). Uses Neovim's native `set title` mechanism with titlestring format. Title updates automatically when changing directories via `:cd`, `:lcd`, or Netrw.

### yanky (`config/yanky.nix`)

[yanky.nvim](https://github.com/gbprod/yanky.nvim) provides yank history with conditional system clipboard integration. Mapping: `<leader>p` to open yank ring in normal and visual modes. Clipboard sync via `vim.opt.clipboard = "unnamedplus"` is conditionally enabled only on safe platforms:
- **macOS:** Always enabled (pbcopy is native)
- **Linux X11:** Enabled if `DISPLAY` is set (xclip available)
- **Linux Wayland:** Enabled only if `wl-copy` is available
- **Other:** Disabled to prevent freezes from unavailable/misconfigured clipboard providers

### vue-macros (`config/vue-macros.nix`)

Editor macros for Vue 3/TypeScript: storeToRefs wrapper, composable scaffolding, props-to-refs converter, destructuring helper, and go-to-definition alias. Exposed under `<leader>m*` keybindings.

### persistence.nvim (`config/persistence.nix`)

[folke/persistence.nvim](https://github.com/folke/persistence.nvim) provides automatic session save/restore. Sessions stored in `~/.local/state/nvim/sessions/` with optional git branch tracking. Saves only when more than 1 file is open. Four keybindings: restore current/select/restore last/don't save. Dashboard integration via `s` key.

### spider (`config/spider.nix`)

[chrisgrieser/nvim-spider](https://github.com/chrisgrieser/nvim-spider) provides smart word navigation that respects camelCase and snake_case boundaries. Replaces default `w`, `e`, `b` motions with context-aware variants in normal, visual, and operator-pending modes. Three keybindings: `w` (start of word), `e` (end of word), `b` (back word).

### treesitter (`config/treesitter.nix`)

Treesitter configuration with 33 language grammars for syntax highlighting, indentation, and code folding. Languages: bash, c, css, html, javascript, jsdoc, json, lua, nix, tsx, typescript, vim, diff, markdown, printf, query, regex, toml, xml, yaml, luadoc, luap, vimdoc, vue. Foldlevel set to 99 (all folds open by default).

### treesitter-textobjects (`config/treesitter-textobjects.nix`)

[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) provides syntax-aware text objects for code navigation and selection. Two modes:

**Move Mode** - Jump between code structures:
- Navigate to next/previous function, class, or parameter start/end
- Keybinds: `]f`, `[f`, `]F`, `[F`, `]c`, `[c`, `]C`, `[C`, `]a`, `[a`, `]A`, `[A]`
- Works in normal, visual, and operator-pending modes
- Automatically sets jumps in the jumplist

**Select Mode** - Select code structures as text objects:
- Define custom text objects like Vim's built-in `ap` (around paragraph)
- Keybinds: `af`/`if`, `ac`/`ic`, `aa`/`ia`
- Automatic lookahead: jumps forward to the textobject automatically
- Selection modes: linewise for functions/classes, charwise for parameters
- Works in visual and operator-pending modes

**Examples:**
- `vif` - Select inside function (visual mode)
- `daf` - Delete around function
- `cic` - Change inside class
- `]f` - Jump to next function start
- `[C` - Jump to previous class end

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

### windows (`config/windows.nix`)

LazyVim-style window and split management keymaps. Features:

**Window Navigation (Ctrl+hjkl):**
- `<C-h>` - Go to left window
- `<C-j>` - Go to lower window
- `<C-k>` - Go to upper window
- `<C-l>` - Go to right window

**Window Resizing (Ctrl+Arrow):**
- `<C-Up>` - Increase window height
- `<C-Down>` - Decrease window height
- `<C-Left>` - Decrease window width
- `<C-Right>` - Increase window width

**Split Creation (Leader+symbol):**
- `<leader>-` - Split window below
- `<leader>|` - Split window right

**Window Management (Leader+w):**
- `<leader>wd` - Delete window

### godot (`config/godot.nix`)

[godotdev.nvim](https://github.com/Mathijs-Bakker/godotdev.nvim) provides comprehensive Godot 4 development support including GDScript LSP, GDShader syntax highlighting, DAP debugging, automatic formatting, and built-in Godot documentation. Features:

**LSP & Syntax:**
- GDScript language server on port 6005 (Godot 4.x standard)
- GDShader TreeSitter syntax highlighting and LSP support
- Auto-detection of `project.godot` files with connection notifications

**Debugging:**
- DAP integration for GDScript debugging
- Debug port 6006 configured

**Development Tools:**
- Automatic formatting with `gdscript-formatter` (4-space indent)
- Built-in Godot class documentation: `:GodotDocs [ClassName]`
- Health checks: `:checkhealth godotdev`
- Scene runners: `:GodotRunProject`, `:GodotRunCurrentScene`, etc.

**Editor Integration:**
- Reconnect to Godot LSP: `:GodotReconnectLSP`
- Optional editor server management: `:GodotStartEditorServer`

Note: Requires Godot 4.x with TCP LSP enabled (Editor Settings → Network → Language Server)

## Language Support (`config/languages/`)

Language support is organized into unified per-language files in `config/languages/`. Each file contains all necessary configuration: TreeSitter grammar references, LSP servers, and formatter setup. TreeSitter grammars are centrally managed in `config/treesitter.nix`.

### _shared (`config/languages/_shared.nix`)

Global LSP configuration shared across all language servers:
- **onAttach hook:** Common setup applied when any LSP attaches (e.g., disabling semantic tokens for certain servers)
- **LSP utilities:** Shared functions and configurations for LSP behavior

### web (`config/languages/web.nix`)

Web language support with:
- **TreeSitter grammars:** JavaScript, TypeScript, JSX, TSX, Vue
- **LSP servers:**
  - `vtsls`: TypeScript/JavaScript with Vue support via `@vue/typescript-plugin`
  - `vue_ls`: Vue template support (hybrid mode with vtsls)
  - `eslint`: Linting for JS/TS/Vue/JSON
- **Formatter:** Prettier

### nix (`config/languages/nix.nix`)

Nix language support with:
- **TreeSitter grammar:** Nix syntax highlighting
- **LSP server:** `nixd` for semantic completions and diagnostics
- **Formatter:** nixfmt

### json (`config/languages/json.nix`)

JSON language support with:
- **TreeSitter grammar:** JSON syntax highlighting
- **LSP server:** `jsonls` with schema validation (package.json, tsconfig.json, tailwind.config.json, etc.)
- **Formatter:** Prettier

### markdown (`config/languages/markdown.nix`)

Markdown language support with:
- **TreeSitter grammars:** Markdown, markdown_inline
- **LSP server:** `marksman` for completions, diagnostics, and cross-file references
- **Formatter:** Prettier

### python (`config/languages/python.nix`)

Python language support with:
- **TreeSitter grammar:** Python syntax highlighting
- **LSP server:** `pyright` with standard type checking mode for completions and diagnostics
- **Formatter:** black for consistent code formatting
- **Linting:** Integrated with `ruff` via `tools/linting.nix` for fast diagnostics

## Tools (`config/tools/`)

Cross-cutting tools and shared functionality organized in `config/tools/`.

### linting (`config/tools/linting.nix`)

Code linter using Nvim-lint with automatic triggers (BufWritePost, BufReadPost, InsertLeave). Configured linters:
- **Nix files:** `statix`, `deadnix`
- **Python files:** `ruff` for fast comprehensive linting and style checking

### lsp-rename (`config/tools/lsp-rename.nix`)

Shared LSP rename utility implementing three-phase workspace file operation protocol. Provides `_G.lsp_rename_file()` Lua function used by Neo-tree and `<leader>cR` keybind. Coordinates all active LSP clients: Phase 1 (workspace/willRenameFiles) pre-processes edits, Phase 2 performs file operation, Phase 3 (workspace/didRenameFiles) notifies servers. Supports multi-client scenarios like .vue files (vtsls + vue_ls coordination).

### lsp-keymaps (`config/tools/lsp-keymaps.nix`)

LSP-focused keybindings: `<leader>ca` opens fzf-lua code action picker. `<leader>cA` filters source actions (fixAll, organizeImports). `<leader>cF` auto-applies fixAll. `<leader>cf` formats via `Conform`. `<leader>cr` renames symbol, `<leader>cR` renames file with LSP updates. `<C-s>` (normal+insert) saves, formats, and shows notification. Definition/declaration lookups use fzf-lua for multiple results, inline edit for single result.

### json-sort-auto (`config/tools/json-sort-auto.nix`)

Auto-sort JSON keys alphabetically on save via `:CdnSort` command and autocmds.

## Agent instructions

After completing any task in this project, **always run `/update-docs`** to keep `AGENTS.md` accurate. This includes:

the update-docs command is under .opencode/commands/update-docs.md

- Adding a new plugin or config file
- Changing a keybind
- Modifying LSP, formatter, or colorscheme config
- Any change to `config/default.nix`
