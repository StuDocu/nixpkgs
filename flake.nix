{
  description = "StuDocu custom packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    git-hooks,
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    checks.${system} = {
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          # editorconfig-checker.enable = true;
          nil.enable = true;
          statix.enable = true;
        };
      };
    };
    packages.${system} = {
      selenium = pkgs.callPackage ./selenium {};
      ecr-credential-provider = pkgs.callPackage ./ecr-credential-provider {};
    };

    formatter.${system} = pkgs.alejandra;

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;

      buildInputs =
        self.checks.${system}.pre-commit-check.enabledPackages
        ++ [
          pkgs.git
        ];
    };
  };
}
