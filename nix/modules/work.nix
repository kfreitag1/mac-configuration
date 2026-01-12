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
  };
}
