{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.shellFor {
  # Ensure the project, including Hakyll, is available in your Nix environment
  packages = p: [ p.hakyll ];
  tools = [ pkgs.stack ];
  buildInputs = [ pkgs.zlib pkgs.gcc ];
  shellHook = ''
    export LIBRARY_PATH=${pkgs.zlib}/lib:$LIBRARY_PATH
  '';
}
