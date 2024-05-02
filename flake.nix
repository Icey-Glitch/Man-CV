{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-vscode-extensions,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in rec {
        name = "pages";
        packages.pages = import ./default.nix {pkgs = pkgs;};
        packages.default = packages.pages;
        apps.default =
          flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "pages" "${pkgs.python3}/bin/python3 -m http.server 8000 -d ${packages.pages}";
          };

        devShells = with pkgs; {
          default = mkShell {
            name = "dev";
            # 👇 we can just use `rustToolchain` here:

            packages = [
              alejandra
              statix
              nil
              nixd
              statix
              vulnix
            ];
          };
        };
      }
    );
}
