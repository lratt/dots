{ self, pkgs, ... }:
{
  services.nix-daemon.enable = true;

  users.users.lr = {
    name = "lr";
    home = "/Users/lr";
  };

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask-fonts"
      "zackelia/formulae" # bclm
    ];
    brews = [
      "bclm"
      "pyenv"
      "gettext" # required for python to build :-)
    ];
    casks = [
      {
        name = "font-jetbrains-mono-nerd-font";
        greedy = true;
      }
      {
        name = "font-iosevka";
        greedy = true;
      }
      {
        name = "monitorcontrol";
        greedy = true;
      } # monitor control on mac
      {
        name = "mos";
        greedy = true;
      } # better mouse control on mac
      {
        name = "macfuse";
        greedy = true;
      } # mac fuse support
      {
        name = "maccy";
        greedy = true;
      } # mac clipboard history
      {
        name = "keepingyouawake";
        greedy = true;
      } # caffeinate wrapper
      {
        name = "raycast";
        greedy = true;
      } # spotlight alternative
      {
        name = "rectangle";
        greedy = true;
      } # window management
      {
        name = "appcleaner";
        greedy = true;
      } # better app cleanup
      {
        name = "tableplus";
        greedy = true;
      } # mysql client
      {
        name = "studio-3t";
        greedy = true;
      } # mongo client
      {
        name = "wireshark";
        greedy = true;
      }
      {
        name = "docker";
        greedy = true;
      }
      {
        name = "visual-studio-code";
        greedy = true;
      }
      {
        name = "zed";
        greedy = true;
      }
      {
        name = "jetbrains-toolbox";
        greedy = true;
      }
      {
        name = "figma";
        greedy = true;
      }
      {
        name = "obsidian";
        greedy = true;
      }
      {
        name = "transmission";
        greedy = true;
      } # bittorrent client
      {
        name = "utm";
        greedy = true;
      } # qemu / virtualization
      {
        name = "slack";
        greedy = true;
      }
      {
        name = "discord";
        greedy = true;
      }
      {
        name = "firefox";
        greedy = true;
      }
      {
        name = "eloston-chromium";
        greedy = true;
      }
      {
        name = "spotify";
        greedy = true;
      }
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      Xcode = 497799835;
    };

    global.autoUpdate = true;
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
  };

  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;

  system.defaults.dock = {
    mru-spaces = false;
    showhidden = true;
    magnification = false;
    autohide = true;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.5;
    show-recents = false;
    persistent-others = [ "/Users/lr/Downloads" ];
  };

  system.defaults.finder = {
    FXPreferredViewStyle = "Nlsv";
    QuitMenuItem = true;
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXShowPosixPathInTitle = true;
  };

  programs.zsh.enable = true; # default shell on catalina

  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = "nix-command flakes";
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
