{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      vue
      typescript
      javascript
      tsx
      css
      html
      json
      jsdoc
      lua
      bash
      nix
    ];
  };
}
