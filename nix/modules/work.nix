{ pkgs, ... }:
{
  environment.variables.MACHINE_PROFILE = "work";

  system.activationScripts.stowProfile.text = ''
    ${pkgs.stow}/bin/stow -d /Users/kieran/config -t /Users/kieran/.config work
  '';

  # nix-daemon is managed by tec, not nix-darwin
  nix.enable = false;

  environment.systemPackages = with pkgs; [

  ];

  homebrew = {
    enable = true;
    taps = [ ];
    brews = [
      "yarn"
      "ykman"
      "docker"
      "colima"
      "docker-compose"
      "ruby"
      "pnpm"
    ];
    casks = [
      "google-cloud-sdk"
      "proxyman"
    ];
  };
}
