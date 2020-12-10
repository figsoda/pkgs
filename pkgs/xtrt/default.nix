{ sources, stdenv }:

stdenv.mkDerivation {
  name = "xtrt";
  src = sources.xtrt;
  installPhase = ''
    sed -i '1s/#!.*/#!\/usr\/bin\/env nix-shell\n#!nix-shell -i bash -p gnutar gzip unzip xz/' xtrt
    mkdir -p $out/bin;
    cp xtrt $out/bin;
  '';
}
