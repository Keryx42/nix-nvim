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
      python
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
      # PHP & Backend
      php
      phpdoc
      blade
      # Game development
      gdscript
      gdshader
    ];
  };

  # Set default foldlevel to expand all folds by default
  # foldlevel=99 means all folds are open (folds are only closed if you explicitly `:set foldlevel=N`)
  extraConfigLua = ''
    vim.opt.foldlevel = 99
  '';
}
