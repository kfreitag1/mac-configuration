{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # GUI Applications (Personal)
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm-community
    zoom-us
    vscode

    # Utils
    erlang_28
    corepack_24

    # CLI
    neovim
    docker
  ];

  homebrew = {
    enable = true;
    casks = [
      "daisydisk"
      "lm-studio"
      "adguard"
      "claude"
      "dolphin"
      "sf-symbols"
      "conductor"
      "tailscale-app"
      "docker-desktop"
      "zed"
    ];
    brews = [
      "openfst"
      "openjdk"
      "claude-squad"
      "opencode"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
