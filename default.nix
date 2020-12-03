{ pkgs }:

with pkgs; rec {
  mmtc = callPackage ./pkgs/mmtc { inherit rust; };
  rust = callPackage ./pkgs/rust { };
}
