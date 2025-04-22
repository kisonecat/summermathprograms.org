{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.shellFor {
  # Ensure the project, including Hakyll, is available in your Nix environment
  packages = p: [ p.hakyll ];
  tools = [ pkgs.stack pkgs.unzip ];
  buildInputs = [ pkgs.zlib  ];
  shellHook = ''
    export PKG_CONFIG_PATH="${pkgs.zlib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
    export C_INCLUDE_PATH="${pkgs.zlib.dev}/include:$C_INCLUDE_PATH"
    export LIBRARY_PATH="${pkgs.zlib.dev}/lib:$LIBRARY_PATH"
  '';
}
