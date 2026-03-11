{
  description = "Coding agents environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
                pkgs.claude-code
                pkgs.codex
                pkgs.gemini-cli
                pkgs.kiro-cli
                pkgs.opencode
            ];

            shellHook = ''
                echo "Coding agents shell loaded"
            '';
        };
    };
}