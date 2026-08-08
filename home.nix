{ config, pkgs, lib, user, home-manager-unstable, ... }:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  imports = [
    "${home-manager-unstable}/modules/programs/pi-coding-agent.nix"
  ];
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    ripgrep   # fast search
    fd        # fast find
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
      ${builtins.readFile ./zsh/keybindings.zsh}
      ${builtins.readFile ./zsh/functions.zsh}
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
  ## fzf configurations
  ######################################################################
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  ######################################################################
  ## starship prompt configuration
  ######################################################################
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };
  ######################################################################
  ## pi-coding-agent configurations
  ######################################################################
  programs.pi-coding-agent = {
    enable = true;
    context = ./home/AGENTS.md;
    settings = lib.importJSON ./home/.pi/agent/settings.defaults.json;
    models = lib.importJSON ./home/.pi/agent/models.json;
  };
  ######################################################################
  ## Symlinks to config files in the repo
  ######################################################################
  # Edit-in-place: the real file stays in the repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  # Global AGENTS.md file for all agents to read from, symlinked to the same file in each agent's config dir.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
