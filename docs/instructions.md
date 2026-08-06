# Setup & Usage Instructions

This guide covers everything from the initial installation to the daily maintenance of your Nix-managed dotfiles.

## 🛠️ Initial Installation

Follow these steps to set up your environment on a new macOS machine.

1. **Install Nix**: Go to [determinate-systems](https://docs.determinate.systems/) and follow the Getting started section.
    For macOS, run:
    ````sh
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
    ````

2. **Clone the Repo**: Create a directory for your dotfiles and initialize git.
    ````sh
    mkdir -p ~/github/dotfiles
    cd ~/github/dotfiles
    # (Clone your repository here or git init)
    ````

3. **Create Symlink**: Create a symbolic link from this repo to a fixed location in your home directory. This is required for the `rebuild.sh` script and symlinked configs to work.
    ````sh
    ln -sfn $(pwd) ~/.dotfiles
    ````

4. **Initialize Configuration**: 
    - Ensure `flake.nix`, `configuration.nix`, and `flake.lock` exist.
    - Run the flake check to verify the configuration evaluates and builds cleanly:
      ````sh
      nix flake check
      ````

5. **First-Time Install**: Run the initial installation command.
    ````sh
    sudo nix run nix-darwin -- switch --flake .#mac
    ````
    *Note: The `#mac` part refers to the `darwinConfigurations.mac` attribute in `flake.nix`.*

6. **Prepare Rebuild Script**: Make the convenience script executable.
    ````sh
    chmod +x rebuild.sh
    ````

---

## 🔄 Daily Workflow

Once installed, you don't need to use the long `nix run` commands.

### Applying Changes
Whenever you modify a `.nix` file (like `home.nix` or `configuration.nix`):
```sh
./rebuild.sh
```
This script automatically updates the `~/.dotfiles` symlink and triggers `darwin-rebuild switch`.

### Updating Packages
To update all your Nix packages and inputs to their latest versions (as defined in your pins):
```sh
nix flake update
./rebuild.sh
```

---

## 🎨 Customization Guide

### 📦 Adding Software
Depending on the type of software, you add it in different places:

- **General CLI Tools (Nix)**: Add to the `home.packages` list in `home.nix`.
  - *Example: Adding `htop` $\rightarrow$ Add `htop` to the list in `home.nix`.*
- **macOS Apps/Brew Formulas (Homebrew)**: Add to `homebrew.brews` or `homebrew.casks` in `configuration.nix`.
  - *Example: Adding `Visual Studio Code` $\rightarrow$ Add `"visual-studio-code"` to `homebrew.casks`.*

### ⚙️ Changing System Preferences
Modify the `system.defaults` section in `configuration.nix` to change macOS behaviors (e.g., Dock settings, Finder views, or Dark Mode).

### 👤 Using on a Different Machine
If you use this repo on a different Mac with a different username:
1. Open `flake.nix`.
2. Change the `user` variable: `let user = "your-username"; in ...`.
3. Run `./rebuild.sh`.

---

## 🧩 Understanding Configuration Methods

This repo uses two different strategies for managing configurations:

### 1. Declarative (The Nix Way)
Settings for **Zsh**, **Starship**, and **Home Manager** are defined directly inside `.nix` files.
- **Pros**: Extremely reproducible; one file defines the entire state.
- **Cons**: Requires running `./rebuild.sh` to apply changes.

### 2. Symlinked (The "Edit-in-Place" Way)
Complex configs (like **Neovim** and **Wezterm**) are stored as folders in `home/.config/` and symlinked to your home directory using `mkOutOfStoreSymlink`.
- **Pros**: You can edit the config file (e.g., `nvim ~/.config/nvim/init.lua`), save it, and the changes take effect immediately without a rebuild.
- **Cons**: The files are managed by the filesystem rather than the Nix store.
