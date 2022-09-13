{
  inputs = {
    marmoset = {
      url = "github:billpugh/marmoset";
      flake = false;
    };
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

  outputs = { self, marmoset, nixpkgs, rust-templates, ymdl }: {
    defaultPackage = self.packages;

    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        inherit (nixpkgs.legacyPackages.${system})
          ant jdk11 jre makeWrapper python3 sd stdenv yt-dlp;
        date = input: builtins.substring 0 8 input.lastModifiedDate;
      in

      {
        rust-templates = stdenv.mkDerivation {
          pname = "rust-templates";
          version = date rust-templates;

          src = rust-templates;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/{bin,lib}
            cp -r bin binlib lib $out/lib
            substitute {,$out/bin/}generate \
              --replace {,$out/lib/}\$1 \
              --replace {,${sd}/bin/}sd
            chmod +x $out/bin/generate

            runHook postInstall
          '';

          meta.mainProgram = "generate";
        };

        umd-cs-submit = stdenv.mkDerivation {
          pname = "umd-cs-submit";
          version = date marmoset;

          src = marmoset;

          nativeBuildInputs = [ ant jdk11 makeWrapper ];

          postPatch = ''
            cd CommandLineSubmission
          '';

          buildPhase = ''
            runHook preBuild

            mkdir bin
            ant

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/{bin,share}
            install -Dm644 submit.jar $out/share
            makeWrapper ${jre}/bin/java $out/bin/umd-cs-submit \
              --add-flags "-cp $out/share/submit.jar edu.umd.cs.submit.CommandLineSubmit"

            runHook postInstall
          '';
        };

        ymdl = stdenv.mkDerivation {
          pname = "ymdl";
          version = date ymdl;

          src = ymdl;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/{bin,lib}
            cp postdl.py $out/lib
            substitute {,$out/bin/}ymdl \
              --replace "python3 postdl.py" "${
                (python3.withPackages (ps: [ ps.pytaglib ])).interpreter
              } $out/lib/postdl.py" \
              --replace yt-dlp ${yt-dlp}/bin/yt-dlp
            chmod +x $out/bin/ymdl

            runHook postInstall
          '';
        };
      });

    overlay = _: super: self.packages.${super.stdenv.hostPlatform.system} or { };
  };
}
