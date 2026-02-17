{ pkgs, ... }:
{
  environment.variables.MACHINE_PROFILE = "work";

  # nix-daemon is managed by tec, not nix-darwin
  nix.enable = false;

  environment.systemPackages = with pkgs; [

  ];

  homebrew = {
    enable = true;
    taps = [ ];
    brews = [
      "yarn"
      "promptfoo"
      "ykman"
      "docker"
      "colima"
      "docker-compose"
      "ruby"
      "pnpm"
    ];
  };
}
