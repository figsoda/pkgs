{ callPackage, rustTools, sources }:

rustTools.buildPackageWithNightly rec {
  pname = "mmtc";
  version = "0.2.6";
  src = sources.mmtc;
}
