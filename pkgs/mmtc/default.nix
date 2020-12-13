{ lib, rustTools, sources }:

rustTools.buildPackageWithNightly {
  pname = "mmtc";
  version = lib.removePrefix "v" sources.mmtc.ref;
  src = sources.mmtc.src;
}
