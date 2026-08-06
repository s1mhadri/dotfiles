# Maintenance Guide

This document describes how to maintain, update, and troubleshoot your Nix-managed environment.

## 📦 Updating Packages and Inputs

Since this repository uses **Nix Flakes**, dependencies are pinned in `flake.lock` for stability. To update them, you must explicitly update the lockfile.

### Update all inputs
To update all pinned inputs (nixpkgs, nix-darwin, home-manager) to their latest compatible versions:
```sh
nix flake update
./rebuild.sh
```

### Update a specific input
If you only want to update `nixpkgs` without touching other inputs:
```sh
nix flake lock --update-input nixpkgs
./rebuild.sh
```

## 🛡️ Validation and Safety

Before applying changes to your system, especially after a `flake update`, it is recommended to verify the configuration.

### Flake Check
Run this to ensure that your configuration is syntactically correct and that the build outputs are consistent:
```sh
nix flake check
```

### Rollbacks
One of the greatest strengths of Nix is the ability to rollback. If a change breaks your system:
1. Use the boot loader (if applicable) or the `darwin-rebuild` history to switch back to a previous generation.
2. To manually switch to a previous generation:
   ```sh
   sudo darwin-rebuild --switch-generation <generation-number>
   ```

## 🧹 Housekeeping

### Garbage Collection
Nix keeps every version of your configuration in the `/nix/store`. Over time, this can consume significant disk space.

**Remove old generations:**
```sh
sudo nix-collect-garbage -d
```
*Warning: This deletes all previous generations. You will not be able to roll back to them.*

### Optimizing the Store
To remove duplicate files across different packages in the Nix store:
```sh
sudo nix-store --optimize
```

## 🛠️ Troubleshooting

### Broken Symlinks
If your config files in `~/.config` stop working, ensure the root symlink is correct:
```sh
ln -sfn ~/github/dotfiles ~/.dotfiles
```

### Homebrew Conflicts
If a Homebrew package is conflicting with a Nix package:
1. Check if the package is available in Nix (`home.nix`).
2. If it is, remove it from `configuration.nix` $\rightarrow$ `homebrew.brews`.
3. Run `./rebuild.sh`.
