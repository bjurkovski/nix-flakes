{
  description = "NodeJS dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    lib.url = "../../lib";
  };

  outputs = { self, nixpkgs, lib, ... }:
    let
        mkPkgs = system: import nixpkgs { inherit system; };
    in
    lib.buildDevShellSet {
        inherit mkPkgs;

        makeModule = { pkgs, system }: {
            packages = [
                pkgs.corepack_20 # For npm, pnpm, yarn
                pkgs.nodejs_20
            ];

            shellHook = ''
                echo "NodeJS dev shell loaded"
            '';
        };
    };
}