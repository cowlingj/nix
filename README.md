# NixOS and Home Manager Configuration

## Getting Started

1. Setup Home Manager
`nix run nix-community/home-manager/release-25.05 -- init --switch`

2. Deploy system
`nixos-rebuild switch --flake .#your-hostname`

3. Deploy Home Manager Configiguration
`home-manager switch --flake .#your-username@your-hostname`
