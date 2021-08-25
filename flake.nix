{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ymdl = {
      url = "github:figsoda/ymdl";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: rec {
    defaultPackage = packages;

    packages = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system:
      let
        inherit (nixpkgs.legacyPackages.${system}) python3 stdenv yt-dlp;
        sources = with builtins; (fromJSON (readFile ./flake.lock)).nodes;
      in {
        ymdl = stdenv.mkDerivation {
          pname = "ymdl";
          version = "unstable-${sources.ymdl.locked.rev}";
          src = inputs.ymdl;
          installPhase = ''
            mkdir -p $out/{bin,lib}
            cp postdl.py $out/lib
            substitute {,$out/bin/}ymdl \
              --replace "python3 postdl.py" "${
                (python3.withPackages (ps: [ ps.pytaglib ])).interpreter
              } $out/lib/postdl.py" \
              --replace yt-dlp ${yt-dlp}/bin/yt-dlp
            chmod +x $out/bin/ymdl
          '';
          meta.mainProgram = "ymdl";
        };
      });

    overlay = _: super: packages.${super.system};
  };
}
