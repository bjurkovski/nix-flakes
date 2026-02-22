{
  description = "Rust dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, ... }:
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
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          };
        }
      );
  in
  {
    devShells = forAllSystems ({ pkgs }: {
      default = pkgs.mkShell {
        name = "rust-dev-shell";

        packages = [
          (pkgs.rust-bin.stable."1.87.0".default.override {
            extensions = [ "rust-analyzer" ];
            targets = [
              "wasm32-unknown-unknown"
              "aarch64-unknown-linux-gnu"
              "x86_64-unknown-linux-gnu"
              "x86_64-unknown-linux-musl"
            ];
          })

          pkgs.cargo-zigbuild
          pkgs.llvmPackages.bintools
          pkgs.patchelf
          pkgs.wasm-pack
        ];

        shellHook = ''
          echo "🦀 Rust dev shell loaded ($(rustc --version))"
          export RUST_BACKTRACE=1
        '';
      };
    });
  };
}