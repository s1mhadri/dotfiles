{ user, ... }:

{
  ##########################################################################
  ## 1. Core System Configuration
  ##########################################################################

  # Version used for backwards compatibility.
  # Change only when intentionally upgrading nix-darwin defaults.
  system.stateVersion = 6;

  system.primaryUser = user;

  users.users.${user} = {
    home = "/Users/${user}";
  };

  ##########################################################################
  ## 2. Nix Configuration
  ##########################################################################

  # [Determinate Nix Installer](https://docs.determinate.systems) manages the daemon.
  # Prevent nix-darwin from trying to manage it.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  ##########################################################################
  ## 3. macOS System Preferences
  ##########################################################################

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";

      # Keyboard
      KeyRepeat = 2;
      InitialKeyRepeat = 15;

      # UI
      _HIHideMenuBar = true;
      AppleShowAllExtensions = true;
    };

    dock = {
      autohide = true;
    };

    finder = {
      FXPreferredViewStyle = "Clmv"; # Column view
      CreateDesktop = false;
    };

    trackpad = {
      Clicking = false;
    };
  };

  ##########################################################################
  ## 4. Homebrew
  ##########################################################################

  # Install and manage Homebrew through Nix.
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  # Configure Homebrew packages and settings.
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      extraFlags = [ "--force" ];
    };

    # Command-line tools
    brews = [
      "nvm"
      "llama.cpp"
      "ollama"
      "pi-coding-agent"
      "opencode"
      "herdr"
    ];

    # GUI applications
    casks = [
      "wezterm"
      "codex-app"
      "opencode-desktop"
    ];
  };
}
