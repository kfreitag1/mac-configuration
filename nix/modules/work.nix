{ config, pkgs, ... }:
let
  repoRoot = "${config.users.users.${config.system.primaryUser}.home}/Developer/mac-configuration";
in
{
  environment.variables.MACHINE_PROFILE = "work";

  my.profileFiles.sourceDir = ../../work;
  my.profileFiles.linkSourceDir = "${repoRoot}/work";

  # nix-daemon is managed by tec, not nix-darwin
  nix.enable = false;

  environment.systemPackages = with pkgs; [
    lazygit
  ];

  homebrew = {
    enable = true;
    brews = [
      "yarn"
      "ykman"
      "docker"
      "colima"
      "docker-compose"
      "ruby"
      "pnpm"
      "redis"
    ];
    casks = [
      "google-cloud-sdk"
      "proxyman"
      "keycastr"
      "redisinsight"
    ];
  };
}
