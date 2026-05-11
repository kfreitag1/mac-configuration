{ config, pkgs, lib, ... }:

let
  secretsConfig = import ./secrets/secrets.nix;

  secretNames = lib.mapAttrsToList (name: _:
    lib.removeSuffix ".age" name
  ) secretsConfig;

  mkSecret = name: {
    file = ./secrets/${name}.age;
    mode = "400";
    owner = "kieran";
    group = "staff";
  };
in
{
  age = {
    secrets = lib.genAttrs secretNames mkSecret;
    identityPaths = [ "/Users/kieran/.ssh/id_ed25519" ];
  };
}
