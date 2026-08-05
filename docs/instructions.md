1. Go to [determinate-systems](https://docs.determinate.systems/) and follow the Getting started section

2. For macOS, download the package or run the following command in terminal
    ````sh
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
    ````

3. Create the repo where you would normally save your github repos and call it `dotfiles/`
    ````sh
    cd path/to/github/repos
    mkdir dotfiles
    ````

4. Initialize git in the repo for tracking and versioning
    ````sh
    git init
    ````

5. Create a symbolic link from this repo to a fixed location in home directory
    ````sh
    ln -sfn path/to/repo/dotfiles/ ~/.dotfiles
    ````

6. Use [nix-darwin](https://github.com/nix-darwin/nix-darwin) for managing macOS using nix

7. Create the boilerplate `flake.nix` and `configuration.nix` files

8. run the flake check command and verify there are no errors
    ````sh
    nix flake check
    ````
    you will get `flake.lock`. This locks exact revisions of:
    - nixpkgs
    - nix-darwin
    
    so future builds are reproducible.

9. For the first time, run the initial installation command
    ````sh
    sudo nix run nix-darwin -- switch --flake path/to/flake/file#mac
    ````
    The `#mac` part refers to `darwinConfigurations.mac = ...` attribute.

10. After nix-darwin is installed and managing the system, you normally use:
    ````sh
    sudo darwin-rebuild switch --flake path/to/flake/file#mac
    ````
