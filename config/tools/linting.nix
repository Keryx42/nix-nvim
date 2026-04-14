{ ... }:
{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [ "statix" "deadnix" ];
    };
    # Linting is triggered on these events:
    # - BufWritePost: after file write
    # - BufReadPost: after file read
    # - InsertLeave: when leaving insert mode
  };
}
