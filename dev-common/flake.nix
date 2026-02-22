{
  description = "Basic dev environment";

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
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs { inherit system; };
        }
      );
  in
  {
    devShellModules = forAllSystems ({ pkgs }: {
        default = {
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
    });

    devShells = forAllSystems ({ pkgs }: {
      default =
        let
          module = self.devShellModules.${pkgs.system}.default;
        in
        pkgs.mkShell {
          packages = module.packages;
          shellHook = module.shellHook;
        };
    });
  };
}