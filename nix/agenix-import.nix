{ lib, ... }:

let
  mkSecret = name: {
    file = ./secrets/${name}.age;
    mode = "400";
    owner = "kieran";
    group = "staff";
  };

  commonSecrets = [ "github-token" ];
in
{
  age = {
    secrets = lib.genAttrs commonSecrets mkSecret;
    identityPaths = [ "/Users/kieran/.ssh/id_ed25519" ];
  };
}
