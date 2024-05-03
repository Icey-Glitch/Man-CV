{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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
            drv = pkgs.writeShellScriptBin "pages" "nix build .#pages; busybox httpd -p 8000 -h ./result/";
          };
        apps.reload =
          flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "pagesreload" "busybox pkill -f httpd; nix run .#default";
          };
          formatter = pkgs.alejandra;

        devShells = with pkgs; {
          default = mkShell {
            name = "CV";
            packages = [
              busybox #for webserver
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
