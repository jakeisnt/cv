{
  description = "A flake for building my resume";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildInputs = [ texlive.combined.scheme-full ];
        nativeBuildInputs = [ ];
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
        meta = {
          license = stdenv.lib.licenses.mit;
          maintainers = with lib.maintainers; [ jakeisnt ];
        };
      };
  };
}
