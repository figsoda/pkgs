self: super: with self; {
  mmtc = callPackage ./pkgs/mmtc { };
  rustTools = callPackage ./pkgs/rustTools { };
}
