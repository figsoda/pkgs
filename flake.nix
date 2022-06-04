{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-templates = {
      url = "github:figsoda/rust-templates";
      flake = false;
    };
    ymdl = {
      url = "github:figsoda/ymdl";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, rust-templates, ymdl }: {
    defaultPackage = self.packages;

    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        inherit (nixpkgs.legacyPackages.${system}) python3 sd stdenv yt-dlp;
        date = input: builtins.substring 0 8 input.lastModifiedDate;
      in
      {
        rust-templates = stdenv.mkDerivation {
          pname = "rust-templates";
          version = date rust-templates;
          src = rust-templates;
          installPhase = ''
            mkdir -p $out/{bin,lib}
            cp -r bin binlib lib $out/lib
            substitute {,$out/bin/}generate \
              --replace {,$out/lib/}\$1 \
              --replace {,${sd}/bin/}sd
            chmod +x $out/bin/generate
          '';
          meta.mainProgram = "generate";
        };

        ymdl = stdenv.mkDerivation {
          pname = "ymdl";
          version = date ymdl;
          src = ymdl;
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
        };
      });

    overlay = _: super: self.packages.${super.stdenv.hostPlatform.system} or { };
  };
}
