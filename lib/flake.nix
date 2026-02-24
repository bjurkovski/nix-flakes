{
  description = "Shared flake definitions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system: f system);
    
    /*
        buildDevShellSet :: {
            makeModule = { pkgs, system }: { packages, shellHook, ... };
        } -> {
            devShellModules.${system}.default = { ... };
            devShells.${system}.default = mkShell ...
        }
    */
    buildDevShellSet = { makeModule, mkPkgs }:
        let
            devShellModules = forAllSystems (system:
                let
                    pkgs = mkPkgs system;
                in {
                    default = makeModule { inherit pkgs system; };
                });
            
            devShells = forAllSystems (system:
                let
                    pkgs = mkPkgs system;
                    module = devShellModules.${system}.default;
                in {
                    default = pkgs.mkShell {
                        packages = module.packages or [];
                        shellHook = module.shellHook or "";
                    };  
                });
        in {
            inherit devShellModules devShells;
        };
  in {
    inherit supportedSystems forAllSystems buildDevShellSet;
  };
}