{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    lazygit
    neovim
    cmake
    eza
    ffmpeg
    gh
    gnupg
    livekit
    livekit-cli
    pnpm
    rbenv
    uv
    # fonts
    nerd-fonts.hack
  ];

  home.sessionVariables.EDITOR = "nvim";

  fonts.fontconfig.enable = true;

  ######################################################################
  ## shell configuration
  ######################################################################

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      uvup = "uv tool upgrade --all";
      pn = "pnpm";
      brewup = "brew update && brew upgrade";
      ls = "eza --long --icons=auto";
      lssz = "eza --long --reverse --sort=size";
      lg = "lazygit";
    };
  };

  ######################################################################
  ## Symlinks to config files in the repo
  ######################################################################

  # Edit-in-place: the real file stays in the repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
}
