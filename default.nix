self: super: 

with builtins;
with super;

let
  sources = mapAttrs
    (k: v: fetchFromGitHub v)
    (fromJSON (readFile ./sources.lock.json));
in rec {
  luaformatter = callPackage ./pkgs/luaformatter { inherit sources; };
  mmtc = callPackage ./pkgs/mmtc { inherit rustTools sources; };
  rustTools = callPackage ./pkgs/rustTools { inherit sources; };
  xtrt = callPackage ./pkgs/xtrt { inherit sources; };
}
