{ pkgs, ... }:
{
  environment.variables.MACHINE_PROFILE = "personal";

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
    taps = [
      "LizardByte/homebrew" # For sunshine
    ];
    casks = [
      "google-chrome"
      "daisydisk"
      "lm-studio"
      "adguard"
      "claude"
      "dolphin"
      "sf-symbols"
      "conductor"
      "tailscale-app"
      "docker-desktop"
      "blackhole-2ch"
      "claude-code"
      "whatsapp"
      "comfyui"
      "dolphin"
    ];
    brews = [
      "openfst"
      "openjdk"
      "claude-squad"
      "sunshine"
      "gemini-cli"
      "lazygit"
      "lazydocker"
    ];
  };
}
