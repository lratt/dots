{ pkgs, lib, vars, ... }:

{
  home.stateVersion = "24.11";

  home.username = "${vars.user}";
  home.homeDirectory = "${vars.home}";

  home.shellAliases = {
    ls = "eza";
  };

  home.sessionPath = [
    "/Users/lr/.local/bin"
    "/Users/lr/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_SSH_COMMAND = "ssh -i ~/.ssh/id_lratt";
  };

  home.packages = with pkgs;
    [
      marksman
      shellcheck
      luajit
      vale
      nil
      nixfmt-rfc-style
      lua-language-server
      nodePackages.typescript-language-server
      pyright
      inetutils
      jq
      xsv
      bat
      fd
      eza
      du-dust
      ripgrep
      delta
      coreutils
      gnused
      nmap
      htop
      opentofu
    ] ++ lib.optional stdenv.isDarwin [ reattach-to-user-namespace ];

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi
      $if mode=vi

      set keymap vi-command
      # these are for vi-command mode
      Control-l: clear-screen

      set keymap vi-insert
      # these are for vi-insert mode
      Control-l: clear-screen
      $endif
    '';
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    history = {
      extended = true;
      save = 100000;
      size = 100000;
    };
    initExtra = ''
      if type brew &>/dev/null
      then
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"

        autoload -Uz compinit
        compinit
      fi

      if [ "$(arch)" = "arm64" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"

        x86() {
          arch -x86_64 /bin/zsh
        }
      else
        export PROMPT="X86 $PROMPT"
        eval "$(/usr/local/bin/brew shellenv)"
      fi

      bindkey '^ ' autosuggest-accept
    '';
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    lfs.enable = true;

    userName = "lratt";
    userEmail = "104203130+lratt@users.noreply.github.com";

    signing = {
      key = "~/.ssh/id_lratt.pub";
      signByDefault = true;
    };

    ignores = [
      ".idea"
      ".vscode"
      ".DS_Store"
      "venv"
      ".venv"
      ".direnv"
    ];

    extraConfig = {
      pull.rebase = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "zdiff3";
      pull.ff = "only";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    aliases = {
      s = "status -s";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = lib.fileContents ./nvim.lua;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      modus-themes-nvim
      deepwhite-nvim
      indent-blankline-nvim
      nvim-lspconfig
      nvim-lint
      conform-nvim
      comment-nvim
      gitsigns-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      mini-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    sensibleOnTop = true;
    historyLimit = 50000;
    customPaneNavigationAndResize = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -g renumber-windows on

      set -g default-terminal "$TERM"
      set -ag terminal-overrides ",$TERM:Tc"
      set -g default-command "reattach-to-user-namespace -l zsh"
      set-option -sg escape-time 10

      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  programs.home-manager.enable = true;
}
