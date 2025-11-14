{
  description = "Kieran macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin }:
  let
    systemarch = "aarch64-darwin";
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      environment.systemPackages = with pkgs; [
        # GUI Applicaations
        obsidian
        bitwarden-desktop
        jetbrains.webstorm
        jetbrains.rust-rover
        jetbrains.pycharm-community
        zoom-us
        vscode

        # Languages
        erlang_28
        corepack_24
        nodejs_24
        go

        # CLI tools
        gh
        tmux
        jq
        stow
        starship
        fzf
        neovim
        docker
      ];

      homebrew = {
        enable = true;
        casks = [
          "rectangle-pro"
          "google-chrome"
          "daisydisk"
          "lm-studio"
          "karabiner-elements"
          "adguard"
          "claude"
          "ghostty"
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

      system.defaults = {
        dock.showhidden = true;
        dock.autohide = true;
        dock.autohide-delay = 0.0;
        dock.autohide-time-modifier = 0.3;
        dock.show-recents = false;
        # dock.persistent-apps = [
        #   "${pkgs.obsidian}/Applications/Obsidian.app"
        # ];
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
            # Require password immediately after sleep or screen saver begins
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.print.PrintingPrefs" = {
            # Automatically quit printer app once the print jobs complete
            "Quit When Finished" = true;
          };
          # Prevent Photos from opening automatically when devices are plugged in
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

      # Allow TouchID with sudo
      security.pam.services.sudo_local.touchIdAuth = true;
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = systemarch;

      # Necessary for some reason?
      system.primaryUser = "kieran";
      users.users.kieran = {
        name = "kieran";
        home = "/Users/kieran";
      };
    };
  in
  {
    darwinConfigurations."kieran-m4pro" = nix-darwin.lib.darwinSystem {
      system = systemarch;
      modules = [
        configuration
      ];
    };
  };
}
