# Nixvim Configuration

A standalone [Nixvim](https://github.com/nix-community/nixvim) configuration with LazyVim-style features, built as a Nix flake. This config can be:

1. **Tested standalone** with `nix run .` (no system installation required)
2. **Integrated into your system flake** for system-wide availability
3. **Run as `nixvim`** alongside your existing Neovim config without conflicts

## Quick Start (Standalone Testing)

To quickly test this configuration without system integration:

```bash
nix run .
```

This launches Nixvim with the current configuration. All changes to `./config/*` will require a fresh `nix run .` to test.

## Installing as a Flake Input

To integrate this Nixvim config into your NixOS or Darwin system, add it as a flake input.

### Step 1: Add Nixvim to Your Flake

In your system's `flake.nix`, add this to the `inputs` section:

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # ... your other inputs ...
  nixvim-config = {
    url = "git+file:///path/to/this/nixvim";  # Local path
    # Or use a remote repo:
    # url = "github:yourusername/nixvim";
  };
};
```

### Step 2: Access Nixvim in Your System Output

In your system's flake `outputs`, pass the nixvim package to your system configuration:

```nix
outputs = { self, nixpkgs, nixvim-config, ... }@inputs:
{
  # For NixOS systems:
  nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./configuration.nix ];
  };

  # For Darwin systems:
  darwinConfigurations.your-hostname = nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    modules = [ ./darwin-configuration.nix ];
  };
};
```

## NixOS Integration

To add Nixvim to your NixOS system, include it in your `configuration.nix`:

```nix
{ inputs, pkgs, ... }:

{
  # ... your other config ...

  environment.systemPackages = with pkgs; [
    # ... your other packages ...
    inputs.nixvim-config.packages.${pkgs.system}.default
  ];
}
```

After updating your config, rebuild your system:

```bash
sudo nixos-rebuild switch --flake /path/to/your/flake
```

The `nixvim` command will then be available system-wide.

## Darwin (macOS) Integration

To add Nixvim to your macOS system (with Nix or nix-darwin), update your `darwin-configuration.nix`:

```nix
{ inputs, pkgs, ... }:

{
  # ... your other config ...

  environment.systemPackages = with pkgs; [
    # ... your other packages ...
    inputs.nixvim-config.packages.${pkgs.system}.default
  ];
}
```

After updating, rebuild your system:

```bash
darwin-rebuild switch --flake /path/to/your/flake
```

Or if using plain Nix on macOS:

```bash
nix run nix-darwin -- switch --flake /path/to/your/flake
```

The `nixvim` command will then be available system-wide.

## Running Nixvim Alongside Existing Neovim

This configuration installs and runs as the `nixvim` command, **not** as `nvim`. This means:

- Your existing Neovim configuration remains untouched
- Both editors can run simultaneously without conflicts
- Each has its own configuration, plugins, and state

### Usage:

```bash
nvim myfile.txt      # Opens with your regular Neovim
nixvim myfile.txt    # Opens with this Nixvim config
```

This allows you to test Nixvim without committing fully to it, or use both editors for different workflows.

## Configuring

To customize this Nixvim setup:

1. **Modify existing configs** in `./config/`
2. **Add new plugin configs** by creating new `.nix` files
3. **Import new configs** by adding them to `config/default.nix`
4. **Review AGENTS.md** for complete feature documentation and all available keybindings

### Testing Changes

**When running standalone:**

```bash
nix run .
```

**After system integration:**

```bash
# Rebuild your system to apply changes
sudo nixos-rebuild switch --flake /path/to/your/flake
# Then launch nixvim
nixvim
```

## Features

This Nixvim configuration includes:

- **Code Navigation:** Treesitter-based textobject navigation (functions, classes, parameters)
- **Auto-tagging:** HTML/JSX tag auto-closing
- **Code Folding:** Treesitter-based folding with sensible defaults
- **LSP:** Built-in language servers (Vue, TypeScript, Nix, ESLint)
- **Formatting:** Prettier, nixfmt, and others via null-ls
- **Fuzzy Finder:** fzf-lua with ripgrep integration
- **Git Integration:** Neogit for Git UI, gitsigns for inline hunks
- **Session Management:** Auto-save/restore with persistence.nvim
- **Syntax Highlighting:** 33+ language grammars via Treesitter

See [AGENTS.md](./AGENTS.md) for the complete plugin list, all keybindings, and detailed feature documentation.

## Testing Your Configuration

### Standalone:

```bash
nix flake check
nix run .
```

### After System Integration:

```bash
# Rebuild system with updated config
sudo nixos-rebuild switch --flake /path/to/your/flake

# Launch nixvim
nixvim
```

## Flake Outputs

This flake provides:

- `packages.${system}.default` — The Nixvim binary
- `checks.${system}.default` — Configuration validation check

When integrated into your system, you're using the `packages.default` output as the `nixvim` command.
