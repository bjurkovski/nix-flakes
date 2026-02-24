{
  description = "AWS/GCP dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    lib.url = "../../lib";
  };

  outputs = { self, nixpkgs, lib, ... }:
    let
        mkPkgs = system: import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in
    lib.buildDevShellSet {
        inherit mkPkgs;

        makeModule = { pkgs, system }: {
            packages = [
                pkgs.awscli2
                pkgs.colima
                pkgs.docker
                pkgs.terraform
            ];

            shellHook = ''
                echo "AWS/GCP dev shell loaded"
            '';
        };
    };
}