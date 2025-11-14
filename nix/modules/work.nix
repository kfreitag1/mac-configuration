{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

  ];

  homebrew = {
    enable = true;
    casks = [

    ];
    brews = [

    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
