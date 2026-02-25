# NixOS and Home Manager Configuration

## Getting Started

1. Setup Home Manager
`nix run nix-community/home-manager/release-25.05 -- init --switch`

2. Deploy system
`nixos-rebuild switch --flake .#your-hostname`

3. Deploy Home Manager Configiguration
`home-manager switch --flake .#your-username@your-hostname`

4. Update packages
`nix flake update`

> Clear generations
> nix profile history --profile /nix/var/nix/profiles/system
> sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 3d
> nix-store --gc

## Secrets

files with .token or .secret are encrypted with git-crypt using a symmetric key.
To add secrets ensure you have git-crypt installed (it's recommended to save a dummy secret file first to ensure it will be encrypted).
To decrypt run the command `git-crypt unlock <path/to/key>`,
a base64 encoded key is kept in bitwarden at cowlingj/nix/git-crypt.key (base64 decode the key before using it).
