self: super: with super; rec {
  mmtc = callPackage ./pkgs/mmtc { inherit rustTools; };
  rustTools = callPackage ./pkgs/rustTools { };
}
