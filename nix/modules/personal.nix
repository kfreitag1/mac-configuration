{ pkgs, ... }:
{
  environment.variables.MACHINE_PROFILE = "personal";

  system.activationScripts.stowProfile.text = ''
    ${pkgs.stow}/bin/stow -d /Users/kieran/config -t /Users/kieran/.config personal
  '';

  environment.systemPackages = with pkgs; [
    # GUI Applications (Personal)
    zoom-us
    vscode

    # Utils
    erlang_28
    corepack_24

    # CLI
    neovim
    docker
    clang-tools
  ];

  homebrew = {
    enable = true;
    taps = [
      "LizardByte/homebrew" # For sunshine
      "shopify/shopify"
    ];
    casks = [
      "google-chrome"
      "daisydisk"
      "adguard"
      "claude"
      "dolphin"
      "sf-symbols"
      "conductor"
      "tailscale-app"
      "docker-desktop"
      "blackhole-2ch"
      "whatsapp"
      "comfyui"
      "dolphin"
      "markedit"
      "yaak"
      "1password"
      "qbittorrent"
      "claude-code"
      "anki"
    ];
    brews = [
      "openfst"
      "openjdk"
      "claude-squad"
      "sunshine"
      "gemini-cli"
      "lazygit"
      "lazydocker"
      "pandoc"
      "shopify-cli"
    ];
  };
}
