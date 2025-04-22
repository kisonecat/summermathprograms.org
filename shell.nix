{ pkgs ? import <nixpkgs> {} }:

pkgs.haskellPackages.shellFor {
  # Ensure the project, including Hakyll, is available in your Nix environment
  packages = p: [ p.hakyll ];
  tools = [ pkgs.stack ];
}
