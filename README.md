# nix-packages

My nix packages


## Usage

As an overlay

```nix
# configuration.nix
{
  nixpkgs.overlays = [
    (import (fetchTarball
      https://github.com/figsoda/nix-packages/archive/main.tar.gz))
  ];
}
```

As a set of packages

```nix
import "${fetchTarball https://github.com/figsoda/nix-packages/archive/main.tar.gz}/packages.nix" {}
```


## Available packages

- [luaformatter](https://github.com/koihik/luaformatter)
- [mmtc](https://github.com/figsoda/mmtc)
- rustTools - wrapper around [naersk](https://github.com/nmattia/naersk) and [nixpkgs-mozilla](https://github.com/mozilla/nixpkgs-mozilla) to build rust packages
- [xtrt](https://github.com/figsoda/xtrt)
