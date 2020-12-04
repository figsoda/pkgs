self: super: with builtins self;

let
  sources = mapAttrs
    (k: v: fetchFromGitHub v)
    (fromJSON (readFile ./sources.lock.json));
in rec {
  mmtc = callPackage ./pkgs/mmtc { };
  rustTools = callPackage ./pkgs/rustTools { };
}
