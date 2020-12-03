{ callPackage }:

let
  naerskSrc =
    fetchTarball "https://github.com/nmattia/naersk/archive/master.tar.gz";
  mozillaSrc = fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
in with callPackage "${mozillaSrc}/package-set.nix" { }; rec {
  inherit (latest.rustChannels) beta nightly stable;
  buildRustPackage = naersk.buildPackage;
  buildRustPackageWith = toolchain: (naerskWith toolchain).buildPackage;
  buildRustPackageWithNightly = naerskWithNightly.buildPackage;
  channelOf = rustChannelOf;
  naersk = naerskWith { };
  naerskWith = toolchain:
    callPackage naerskSrc {
      cargo = toolchain;
      rustc = toolchain;
    };
  naerskWithNightly = naerskWith nightly.rust;
}
