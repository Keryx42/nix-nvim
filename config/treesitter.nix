{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      # Web & Scripting
      bash
      c
      css
      html
      javascript
      jsdoc
      json
      lua
      nix
      tsx
      typescript
      vim
      # Markup & Data
      diff
      markdown
      markdown_inline
      printf
      query
      regex
      toml
      xml
      yaml
      # Documentation
      luadoc
      luap
      vimdoc
      # Framework-specific
      vue
    ];
  };
}
