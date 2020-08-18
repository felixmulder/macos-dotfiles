# macOS dotfiles
This if for my macOS setup using nix-darwin to configure window manager,
installed applications and common settings.

## Installation

* [Install nix](https://nixos.org/download.html)
* [Disable SIP](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
* [Install nix-darwin](https://github.com/LnL7/nix-darwin#install)

Run:

```bash
$ darwin-rebuild switch -I "darwin-config=$HOME/<path-to-repo>/configuration.nix"
```
