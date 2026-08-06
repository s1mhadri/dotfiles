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
  ## Symlinks to config files in the repo
  ######################################################################

  # Edit-in-place: the real file stays in the repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
}
