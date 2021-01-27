{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "resume";
  src = pkgs.lib.cleanSource ./.;
  preferLocalBuild = true;

  buildInputs = with pkgs; [ texlive.combined.scheme-full ];
}
