{
  description = "Kieran macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin }:
  let
    systemarch = "aarch64-darwin";

    personalConfig = { pkgs, ... }: {
      imports = [
        ./modules/base.nix
        ./modules/personal.nix
      ];
    };

    workConfig = { pkgs, ... }: {
      imports = [
        ./modules/base.nix
        ./modules/work.nix
      ];
    };
  in
  {
    darwinConfigurations."kieran-m4pro" = nix-darwin.lib.darwinSystem {
      system = systemarch;
      modules = [
        personalConfig
      ];
      specialArgs = { inherit inputs; };
    };

    darwinConfigurations."kieran-work" = nix-darwin.lib.darwinSystem {
      system = systemarch;
      modules = [
        workConfig
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
