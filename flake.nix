{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    ymdl = {
      url = "github:figsoda/ymdl";
      flake = false;
    };
  };

  outputs = { flake-utils, nixpkgs, ... }@inputs:
    with builtins;
    with flake-utils.lib;
    let
      outputs = eachSystem allSystems (system:
        let
          sources = (fromJSON (readFile ./flake.lock)).nodes;
          pkgs = nixpkgs.legacyPackages.${system};
        in rec {
          defaultPackage = packages;

          packages = {
            ymdl = pkgs.stdenv.mkDerivation {
              pname = "ymdl";
              version = "unstable-${sources.ymdl.locked.rev}";
              src = inputs.ymdl;
              installPhase = ''
                mkdir -p $out/{bin,lib}
                cp postdl.py $out/lib
                substitute {,$out/bin/}ymdl \
                  --replace "python3 postdl.py" "${
                    (pkgs.python3.withPackages
                      (ps: [ ps.pytaglib ])).interpreter
                  } $out/lib/postdl.py" \
                  --replace youtube-dl ${pkgs.youtube-dl}/bin/youtube-dl
                chmod +x $out/bin/ymdl
              '';
            };
          };
        });
    in outputs // { overlay = _: super: outputs.packages.${super.system}; };
}
