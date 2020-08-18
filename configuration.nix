{ config, pkgs, ... }:

{
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.show-recents = false;
  system.defaults.dock.showhidden = true;

  system.defaults.finder.AppleShowAllExtensions = true;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;


  environment.systemPackages =
    [
      pkgs.bat
      pkgs.neovim
      pkgs.jq
    ];

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "off";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "off";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 5;
      bottom_padding               = 5;
      left_padding                 = 5;
      right_padding                = 5;
      window_gap                   = 5;
    };
    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off

      # Set up spaces
      yabai -m space 1 --label main
      yabai -m space 2 --label term
      yabai -m space 3 --label misc
      yabai -m space 4 --label chat
      yabai -m space --focus main
    '';
  };

  services.skhd = {
    enable = true;

    skhdConfig = ''
      # Open terminal
      shift + alt - return : open -a iTerm --new

      # fast focus desktop
      shift + alt - x : yabai -m space --focus recent
      shift + alt - l : yabai -m space --focus next
      shift + alt - j : yabai -m space --focus next
      shift + alt - k : yabai -m space --focus prev
      shift + alt - h : yabai -m space --focus prev
      shift + alt - 1 : yabai -m space --focus 1
      shift + alt - 2 : yabai -m space --focus 2
      shift + alt - 3 : yabai -m space --focus 3
      shift + alt - 4 : yabai -m space --focus 4

      # navigate windows on space
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east


      # Move window to different space and follow
      shift + cmd + alt - 1 : yabai -m window --space 1 && \
                              yabai -m space --focus 1
      shift + cmd + alt - 2 : yabai -m window --space 2 && \
                              yabai -m space --focus 2
      shift + cmd + alt - 3 : yabai -m window --space 3 && \
                              yabai -m space --focus 3
      shift + cmd + alt - 4 : yabai -m window --space 4 && \
                              yabai -m space --focus 4
    '';
  };


  environment.darwinConfig = "$HOME/.src/macos-dotfiles/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
