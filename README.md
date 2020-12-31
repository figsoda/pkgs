# nix-packages

My nix packages


## Usage

As a flake (recommended)

```nix
# flake.nix
{
  inputs = {
    figsoda-pkgs.url = "github:figsoda/nix-packages";
  };
}
```

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
import "${fetchTarball https://github.com/figsoda/nix-packages/archive/main.tar.gz}/packages.nix"
```


## Available packages

- [luaformatter](https://github.com/koihik/luaformatter)
- [mmtc](https://github.com/figsoda/mmtc)
- [xtrt](https://github.com/figsoda/xtrt)
