{pkgs ? import <nixpkgs> {}}:
with pkgs;
  stdenv.mkDerivation {
    name = "pages";
    src = ./.;

    nativeBuildInputs = [
      asciidoctor
      html-minifier
      coreutils
    ];

    buildPhase = ''
      # Get current build time
      build_time=$(date -u +"%Y-%m-%d %H:%M:%S")

      # Replace placeholder with build time in AsciiDoc file
      sed -i "s/{build_time}/$build_time/" cv.adoc
      asciidoctor --attribute stylesheet=./css/style.css -a reproducible="true" cv.adoc -o index.html &
      asciidoctor -r asciidoctor-pdf -b pdf --attribute stylesheet=./css/style.css -a reproducible="true" cv.adoc -o cv.pdf &
      wait
      html-minifier index.html --remove-comments --remove-optional-tags --trimCustomFragments --removeEmptyAttributes --remove-redundant-attributes --remove-script-type-attributes --minify-js true --minify-css true
    '';

    installPhase = ''
      mkdir -p $out
      cp index.html $out
      cp cv.pdf $out
      # cp screenshot.webp $out
    '';
  }
