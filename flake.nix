{
  description = "StuDocu custom packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          packages = {
            selenium = pkgs.callPackage ./selenium { };
          };

          formatter = pkgs.nixpkgs-fmt;
        }) // {
      overlays = {
        default = final: prev: {
          studocu = {
            selenium = self.packages.${prev.system}.selenium;
          };
        };
      };
    };
}
