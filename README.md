# nix-packages

My nix packages

Binary cache is available for x86_64-linux on [cachix](https://app.cachix.org/cache/figsoda)

```sh
cachix use figsoda
```


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
      "https://github.com/figsoda/nix-packages/archive/main.tar.gz"))
  ];
}
```

As a set of packages

```nix
import "${
  fetchTarball "https://github.com/figsoda/nix-packages/archive/main.tar.gz"
}/packages.nix"
```


## Available packages

- [ymdl](https://github.com/figsoda/ymdl)
- [rust-templates](https://github.com/figsoda/rust-templates)
