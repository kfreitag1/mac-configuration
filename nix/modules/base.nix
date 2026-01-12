{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    # Languages
    nodejs_24
    go
    (rust-bin.stable.latest.default.override {
      targets = [ "wasm32-unknown-unknown" "wasm32-wasip2" ];
    })

    # CLI tools
    gh
    tmux
    jq
    stow
    starship
    fzf
    uv
    bun
  ];

  homebrew = {
    enable = true;
    casks = [
      "karabiner-elements"
      "rectangle-pro"
      "ghostty"
      "zed"
      "obsidian"
      "bitwarden"
    ];
    brews = [
      "opencode"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.defaults = {
    dock.showhidden = true;
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.3;
    dock.show-recents = false;
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "clmv";
    finder.ShowPathbar = true;
    finder._FXSortFoldersFirst = true;
    finder._FXShowPosixPathInTitle = true;
    finder.AppleShowAllExtensions = true;
    finder.AppleShowAllFiles = true;
    finder.ShowStatusBar = true;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    screencapture.location = "~/Desktop";
    WindowManager.EnableStandardClickToShowDesktop = false;
    WindowManager.EnableTiledWindowMargins = false;
    WindowManager.EnableTilingByEdgeDrag = false;
    WindowManager.EnableTilingOptionAccelerator = false;
    CustomUserPreferences = {
      "com.apple.Finder" = {
        WarnOnEmptyTrash = false;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.screencapture" = {
        location = "~/Desktop";
        type = "png";
      };
      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };
      "com.apple.ImageCapture".disableHotPlug = true;
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.TextEdit" = {
        CheckSpellingWhileTyping = 0;
        CorrectSpellingAutomatically = 0;
        RichText = 0;
      };
    };
  };

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableBashCompletion = true;

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;
  system.primaryUser = "kieran";
  users.users.kieran = {
    name = "kieran";
    home = "/Users/kieran";
  };
}
