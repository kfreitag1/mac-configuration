{ pkgs, ... }:
{
  # Ensure Determinate manages nix, not nix-darwin
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
