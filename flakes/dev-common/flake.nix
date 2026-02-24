{
  description = "Basic dev environment";

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
                pkgs.coreutils
                pkgs.curl
                pkgs.duckdb
                pkgs.git
                pkgs.sqlite
                pkgs.vim
                pkgs.which
                pkgs.zed-editor
            ];

            shellHook = ''
                echo "Basic dev shell loaded"
            '';
        };
    };
}