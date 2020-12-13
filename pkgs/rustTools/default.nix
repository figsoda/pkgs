{ callPackage, sources }:

with callPackage "${sources.mozilla.src}/package-set.nix" { }; rec {
  inherit (latest.rustChannels) beta nightly stable;
  inherit (naersk) buildPackage;
  buildPackageWith = toolchain: (naerskWith toolchain).buildPackage;
  buildPackageWithNightly = naerskWithNightly.buildPackage;
  channelOf = rustChannelOf;
  naersk = naerskWith { };
  naerskWith = toolchain:
    callPackage sources.naersk.src {
      cargo = toolchain;
      rustc = toolchain;
    };
  naerskWithNightly = naerskWith nightly.rust;
}
