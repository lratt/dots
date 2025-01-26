{ self, pkgs, ... }:
{
  services.nix-daemon.enable = true;

  users.users.lr = {
    name = "lr";
    home = "/Users/lr";
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix.settings.trusted-users = [
    "root"
    "lr"
  ];

  homebrew = {
    enable = true;
    casks = [
      {
        name = "iina";
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
        name = "keepingyouawake";
        greedy = true;
      } # caffeinate wrapper
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
        name = "utm";
        greedy = true;
      } # qemu / virtualization
      {
        name = "slack";
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
    autohide = false;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.5;
    show-recents = false;
    tilesize = 56;
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
  nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.8" ];


  nix.settings.experimental-features = "nix-command flakes";
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
