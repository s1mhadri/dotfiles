{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # cli tools
    cmake
    eza
    fd        # fast find
    ffmpeg
    gh
    gnupg
    jq
    lazygit
    livekit
    livekit-cli
    neovim
    pnpm
    rbenv
    ripgrep   # fast search
    uv
    yt-dlp
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
      llamaserve = "llama serve --models-max 1 --models-preset ${dotfiles}/home/.config/llamacpp/models.ini";
    };
  };

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
  ## Symlinks to config files in the repo
  ######################################################################

  # Edit-in-place: the real file stays in the repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/llamacpp".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/llamacpp";

  # Global AGENTS.md file for all agents to read from, symlinked to the same file in each agent's config dir.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".pi/agent/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  # pi configs
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".config/opencode/opencode.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/opencode.json";

  ######################################################################
  ## pi agent settings.json: merge defaults into the live file on every
  ## switch, without clobbering keys the app/user has changed at runtime.
  ## Keys in settings.default.json always win on conflicts; anything else
  ## already in settings.json (app state, etc.) is preserved.
  ######################################################################
  home.activation.piAgentSettings = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    target="${config.home.homeDirectory}/.pi/agent/settings.json"
    defaults="${dotfiles}/home/.pi/agent/settings.default.json"
    tmp="$(mktemp)"

    if [ -e "$target" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$defaults" > "$tmp"
    else
      cp "$defaults" "$tmp"
    fi

    $DRY_RUN_CMD install -D -m644 "$tmp" "$target"
    rm -f "$tmp"
  '';
}
