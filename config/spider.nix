{ pkgs, ... }:
{
  # nvim-spider provides smarter word navigation that respects camelCase and snake_case
  # Replaces default w, e, b motions with context-aware variants in normal, operator-pending, and visual modes
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-spider";
      src = pkgs.fetchFromGitHub {
        owner = "chrisgrieser";
        repo = "nvim-spider";
        rev = "4fdd56a4f45bca13a607632e15a6f9f8d1b1f99e";
        hash = "sha256-2ZJV23CZ8B3x4DPHGuWnq84Jp3gLvyCARuyqtrZEOos=";
      };
    })
  ];

  keymaps = [
    # Spider word motion: end of word
    {
      mode = [ "n" "o" "x" ];
      key = "e";
      action = "<cmd>lua require('spider').motion('e')<cr>";
      options = {
        desc = "Spider: End of word";
        silent = true;
      };
    }

    # Spider word motion: start of word
    {
      mode = [ "n" "o" "x" ];
      key = "w";
      action = "<cmd>lua require('spider').motion('w')<cr>";
      options = {
        desc = "Spider: Start of word";
        silent = true;
      };
    }

    # Spider word motion: back word
    {
      mode = [ "n" "o" "x" ];
      key = "b";
      action = "<cmd>lua require('spider').motion('b')<cr>";
      options = {
        desc = "Spider: Back word";
        silent = true;
      };
    }
  ];
}
