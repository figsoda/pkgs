{ nix, sources, stdenv }:

let
  shebang = ''
    ${nix}/bin/nix-shell
    #!nix-shell -i bash -p gnutar gzip unzip xz
  '';
in stdenv.mkDerivation {
  name = "xtrt";
  src = sources.xtrt;
  installPhase = ''
    mkdir -p $out/bin
    substitute xtrt $out/bin/xtrt --replace "#!/usr/bin/env bash" "${shebang}"
  '';
}
