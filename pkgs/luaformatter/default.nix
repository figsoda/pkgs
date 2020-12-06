{ antlr4, cmake, sources, stdenv }:

stdenv.mkDerivation {
  pname = "luaformatter";
  version = "1.3.4";
  src = sources.luaformatter;
  buildInputs = [ cmake ];
  configurePhase = ''
    rmdir third_party/*
    ln -sT ${sources.antlr4} third_party/antlr4
    ln -sT ${sources.catch2-cpp} third_party/Catch2
    ln -sT ${sources.args-cpp} third_party/args
    ln -sT ${sources.yaml-cpp} third_party/yaml-cpp
    cmake .
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp lua-format $out/bin
  '';
}
