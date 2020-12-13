_: super:

with builtins;
with super;

let
  sources =
    mapAttrs (_: v: v // { src = fetchFromGitHub (removeAttrs v [ "ref" ]); })
    (fromJSON (readFile ./sources.lock.json));
in rec {
  luaformatter = callPackage ./pkgs/luaformatter { inherit sources; };
  mmtc = callPackage ./pkgs/mmtc { inherit rustTools sources; };
  rustTools = callPackage ./pkgs/rustTools { inherit sources; };
  xtrt = callPackage ./pkgs/xtrt { inherit sources; };
}
