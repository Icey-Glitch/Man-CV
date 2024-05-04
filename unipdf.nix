{pkgs ? import <nixpkgs> {}}:
with pkgs;
  stdenv.mkDerivation rec {
    name = "unipdf";
    version = "0.5.0";

    src = fetchzip {
      url = "https://github.com/unidoc/unipdf-cli/releases/download/v${version}/unipdf-${version}-linux-amd64.tar.gz";
      sha256 = "sha256-0HlMpqDCSKB4/WO4riGaTWbZDzR6LTIxva35OCHUFbA=";
    };

    installPhase = ''
      unipdf optimize -r -O ./resultstemp
      mkdir -p $out
      mv unipdf $out
    '';
  }
