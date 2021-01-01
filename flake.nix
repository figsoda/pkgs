{
  inputs = {
    antlr4 = {
      url = "github:antlr/antlr4/4.9";
      flake = false;
    };
    args = {
      url = "github:taywee/args/6.2.4";
      flake = false;
    };
    catch2 = {
      url = "github:catchorg/catch2/v2.13.3";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    luaformatter = {
      url = "github:koihik/luaformatter/1.3.4";
      flake = false;
    };
    mmtc = {
      url = "github:figsoda/mmtc/v0.2.6";
      flake = false;
    };
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xtrt = {
      url = "github:figsoda/xtrt";
      flake = false;
    };
    yaml-cpp = {
      url = "github:jbeder/yaml-cpp/yaml-cpp-0.6.3";
      flake = false;
    };
  };

  outputs = { flake-utils, naersk, nixpkgs, nixpkgs-mozilla, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      with builtins;
      let
        sources = (fromJSON (readFile ./flake.lock)).nodes;
        pkgs = nixpkgs.legacyPackages.${system};
        mozilla = pkgs.callPackage "${nixpkgs-mozilla}/package-set.nix" { };
        rustNightly = (mozilla.rustChannelOf {
          date = "2020-12-30";
          channel = "nightly";
          sha256 = "f2/rc0jI1wzvU/b82nyR+ehLtuOjLv7TjnCmtbUClcA=";
        }).rust;
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

          mmtc = (naersk.lib.${system}.override {
            cargo = rustNightly;
            rustc = rustNightly;
          }).buildPackage {
            pname = "mmtc";
            version = nixpkgs.lib.removePrefix "v" sources.mmtc.original.ref;
            src = inputs.mmtc;
          };

          xtrt = pkgs.stdenv.mkDerivation {
            pname = "xtrt";
            version = substring 0 7 sources.xtrt.locked.rev;
            src = inputs.xtrt;
            patchPhase = ''
              substituteInPlace xtrt \
                --replace "bzip2 " "${pkgs.bzip2}/bin/bzip2 " \
                --replace "gzip " "${pkgs.gzip}/bin/gzip " \
                --replace "tar " "${pkgs.gnutar}/bin/tar " \
                --replace "unzip " "${pkgs.unzip}/bin/unzip " \
                --replace "xz " "${pkgs.xz}/bin/xz "
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp xtrt $out/bin
            '';
          };
        };

        overlay = _: _: packages;
      });
}
