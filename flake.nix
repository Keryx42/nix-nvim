{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, pkgs, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system; # or alternatively, set `pkgs`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
          baseNvim = nixvim'.makeNixvimWithModule nixvimModule;
          # Add tools to nixvim runtime closure for multi-platform support
          # by injecting PATH into the existing wrapper script
          nvim = pkgs.runCommand "nixvim-wrapped" { 
            passAsFile = [ "pathPrepend" ];
            meta.mainProgram = "nvim";
          } ''
            mkdir -p $out/bin
            cp ${baseNvim}/bin/nvim $out/bin/nvim
            
            # Inject gdscript-formatter PATH at the beginning of the wrapper script
            # after the shebang
            sed -i '1a export PATH="${pkgs.gdscript-formatter}/bin:$PATH"' $out/bin/nvim
            chmod +x $out/bin/nvim
            
            # Copy everything else from baseNvim
            cp -r ${baseNvim}/* $out/ 2>/dev/null || true
            
            # Restore our wrapped nvim binary (in case it got overwritten)
            cp ${baseNvim}/bin/nvim $out/bin/nvim.original
            sed -i '1a export PATH="${pkgs.gdscript-formatter}/bin:$PATH"' $out/bin/nvim.original
            rm $out/bin/nvim
            mv $out/bin/nvim.original $out/bin/nvim
          '';
        in
        {
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };
        };
    };
}
