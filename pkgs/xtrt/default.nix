{ sources, stdenv }:

stdenv.mkDerivation {
  name = "xtrt";
  src = sources.xtrt;
  installPhase = ''
    mkdir -p $out/bin;
    cp xtrt $out/bin;
  '';
}
