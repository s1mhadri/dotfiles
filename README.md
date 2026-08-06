# ❄️ dotfiles

A declarative macOS configuration managed by **Nix**. This repository allows for a reproducible development environment across different machines.

## 🚀 Overview

This setup uses a modern Nix ecosystem to manage everything from system-level macOS preferences to user-level shell configurations and applications.

### Core Stack
- **[Nix](https://nixos.org/)**: The functional package manager.
- **[nix-darwin](https://github.com/nix-darwin/nix-darwin)**: For managing macOS system settings and packages.
- **[Home Manager](https://github.com/nix-community/home-manager)**: For managing user-specific configurations (dotfiles, shell, etc.).
- **[Determinate Systems](https://docs.determinate.systems/)**: Used for the Nix installation and daemon management.
- **Homebrew**: Integrated via `nix-homebrew` for packages that are easier to manage via Brew.

## 📂 Project Structure

| File/Folder | Purpose |
| :--- | :--- |
| `flake.nix` | The entry point. Defines inputs (versions) and the system configuration. |
| `configuration.nix` | macOS system settings, system-level packages, and Homebrew configurations. |
| `home.nix` | User-level packages, Zsh aliases, Starship prompt, and environment variables. |
| `home/` | Contains standalone config directories (like `nvim` and `wezterm`) that are symlinked to `~/.config`. |
| `rebuild.sh` | A convenience script to apply changes to the system. |
| `docs/` | Setup and maintenance instructions. |

## 🛠️ Getting Started

If you are setting this up on a new machine, please follow the detailed guide in:
👉 **[docs/instructions.md](./docs/instructions.md)**

## 🔄 Applying Changes

After modifying any `.nix` file or the `home/` directory:

1. **Verify** the configuration:
   ```sh
   nix flake check
   ```

2. **Apply** the changes:
   ```sh
   ./rebuild.sh
   ```

## ⚙️ Configuration Philosophy

- **Declarative**: Most settings (like Zsh and Starship) are defined directly in `home.nix`.
- **Symlinked**: Complex configurations (like Neovim) are stored in the `home/` directory and symlinked using `mkOutOfStoreSymlink`. This allows for "edit-in-place" without needing to run a rebuild for every minor tweak.
- **Reproducible**: Versions are pinned in `flake.nix` to ensure the environment remains stable over time.
