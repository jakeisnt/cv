{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "CV";
  src = pkgs.lib.cleanSource ./.;
  preferLocalBuild = true;

  buildInputs = with pkgs; [ texlive.combined.scheme-full ];
}
