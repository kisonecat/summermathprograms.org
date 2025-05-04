{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.shellFor {
  # Ensure the project, including Hakyll, is available in your Nix environment
  packages = p: [ p.hakyll ];
  tools = [ pkgs.unzip ];
  buildInputs = [ pkgs.haskellPackages.stack pkgs.zlib pkgs.pkg-config pkgs.gcc pkgs.haskellPackages.ghc ];
  shellHook = ''
    export PKG_CONFIG_PATH="${pkgs.zlib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
    export C_INCLUDE_PATH="${pkgs.zlib.dev}/include:$C_INCLUDE_PATH"
    export LIBRARY_PATH="${pkgs.zlib.dev}/lib:$LIBRARY_PATH"
  '';
}
