{ cmake, sources, stdenv }:

stdenv.mkDerivation {
  pname = "luaformatter";
  version = sources.luaformatter.ref;
  src = sources.luaformatter.src;
  buildInputs = [ cmake ];
  configurePhase = ''
    rmdir third_party/*
    ln -sT ${sources.antlr4.src} third_party/antlr4
    ln -sT ${sources.catch2-cpp.src} third_party/Catch2
    ln -sT ${sources.args-cpp.src} third_party/args
    ln -sT ${sources.yaml-cpp.src} third_party/yaml-cpp
    cmake .
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp lua-format $out/bin
  '';
}
