{
  description = "Various Matrix-related packages and modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    utils.url = "github:numtide/flake-utils";
    gomod2nix.url = "github:tweag/gomod2nix";
  };

  outputs = { self, nixpkgs, utils, gomod2nix }: utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            gomod2nix.overlay
          ];
        };
      in {
        packages.rageshake = with pkgs; buildGoApplication rec {
          pname = "rageshake";
          version = "1.2";

          src = fetchFromGitHub {
            owner = "matrix-org";
            repo = "rageshake";
            rev = "v${version}";
            sha256 = "02lnla4kxbg002414nm5qpcx9cz6x0rm99k9yw32bwkni5mncshx";
          };

          modules = ./gomod2nix/rageshake.toml;

          meta = with lib; {
            description = "Web service which collects and serves bug reports";
            homepage = "https://github.com/matrix-org/rageshake";
            license = licenses.asl20;
          };
        };
      }
    );
}
