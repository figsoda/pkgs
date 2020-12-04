self: super: 

with builtins;
with self;

let
  sources = mapAttrs
    (k: v: fetchFromGitHub v)
    (fromJSON (readFile ./sources.lock.json));
in rec {
  mmtc = callPackage ./pkgs/mmtc { inherit sources; };
  rustTools = callPackage ./pkgs/rustTools { inherit sources; };
}
