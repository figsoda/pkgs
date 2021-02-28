{
  inputs = {
    antlr4 = {
      url = "github:antlr/antlr4/4.9.1";
      flake = false;
    };
    args = {
      url = "github:taywee/args/6.2.4";
      flake = false;
    };
    catch2 = {
      url = "github:catchorg/catch2/v2.13.4";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    luaformatter = {
      url = "github:koihik/luaformatter/1.3.4";
      flake = false;
    };
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    yaml-cpp = {
      url = "github:jbeder/yaml-cpp/yaml-cpp-0.6.3";
      flake = false;
    };
    ymdl = {
      url = "github:figsoda/ymdl";
      flake = false;
    };
  };

  outputs = { flake-utils, nixpkgs, ... }@inputs:
    let
      outputs = flake-utils.lib.eachDefaultSystem (system:
        with builtins;
        let
          sources = (fromJSON (readFile ./flake.lock)).nodes;
          pkgs = nixpkgs.legacyPackages.${system};
        in rec {
          defaultPackage = packages;

          packages = {
            luaformatter = pkgs.stdenv.mkDerivation {
              pname = "luaformatter";
              version = sources.luaformatter.original.ref;
              src = inputs.luaformatter;
              buildInputs = [ pkgs.cmake ];
              configurePhase = ''
                rmdir third_party/*
                ln -sT ${inputs.antlr4} third_party/antlr4
                ln -sT ${inputs.catch2} third_party/Catch2
                ln -sT ${inputs.args} third_party/args
                ln -sT ${inputs.yaml-cpp} third_party/yaml-cpp
                cmake .
              '';
              installPhase = ''
                mkdir -p $out/bin
                cp lua-format $out/bin
              '';
            };

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
