let
  lock = (builtins.fromJSON
    (builtins.readFile ./flake.lock)).nodes.flake-compat.locked;
in (import (fetchTarball {
  url =
    "https://github.com/${lock.owner}/${lock.repo}/archive/${lock.rev}.tar.gz";
  sha256 = lock.narHash;
}) { src = ./.; }).defaultNix.default
