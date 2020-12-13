{ nix, sources, stdenv }:

let
  shebang = ''
    #!${nix}/bin/nix-shell
    #!nix-shell -i bash -p gnutar gzip unzip xz
  '';
in stdenv.mkDerivation {
  pname = "xtrt";
  version = builtins.substring 0 7 sources.xtrt.rev;
  src = sources.xtrt.src;
  installPhase = ''
    substituteInPlace xtrt --replace "#!/usr/bin/env bash" "${shebang}"
    mkdir -p $out/bin
    cp xtrt $out/bin
  '';
}
