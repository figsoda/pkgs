{ nix, sources, stdenv }:

let
  shebang = ''
    #!${nix}/bin/nix-shell
    #!nix-shell -i bash -p gnutar gzip unzip xz
  '';
in stdenv.mkDerivation {
  name = "xtrt";
  src = sources.xtrt;
  installPhase = ''
    substituteInPlace xtrt --replace "#!/usr/bin/env bash" "${shebang}"
    mkdir -p $out/bin
    cp xtrt $out/bin
  '';
}
