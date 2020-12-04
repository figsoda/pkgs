{ rustTools, sources }:

rustTools.buildPackageWithNightly {
  pname = "mmtc";
  version = "0.2.6";
  src = sources.mmtc;
}
