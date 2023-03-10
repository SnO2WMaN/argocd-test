{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    yamlfmt = {
      url = "github:SnO2WMaN/yamlfmt.nix";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    yamlfmt,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
          ];
        };
      in {
        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [
            alejandra
            yamlfmt.packages.${system}.yamlfmt
            argocd
            kustomize
            jq
            httpie
          ];
        };
      }
    );
}
