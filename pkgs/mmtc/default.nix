{ callPackage, rust }:

rust.buildRustPackageWithNightly rec {
  pname = "mmtc";
  version = "0.2.6";
  src =
    fetchTarball "https://github.com/figsoda/mmtc/archive/v${version}.tar.gz";
}
