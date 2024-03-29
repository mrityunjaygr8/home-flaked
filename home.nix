{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mgr8";
  home.homeDirectory = "/home/mgr8";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fzf
    less
    difftastic
    lazydocker
    git-credential-manager
    chromium
    devenv
    fd
    ripgrep
    dust
    bottom
    tldr
    neofetch
    go
    python3
    nodePackages.pnpm
    nodePackages.npm
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
  };

  services.gpg-agent = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs = {
    lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            externalDiffCommand = "difft --color=always";
	  };
	};
      };
    };
    gpg = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Mrityunjay Saxena";
      userEmail = "mrityunjaysaxena1996@gmail.com";

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        credential = {
          helper = "store";
        };
      };
    };
    eza = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    bat = {
      enable = true;
      config = {
        theme = "Nord";
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    tmux = {
      enable = true;
      clock24 = true;
      # shortcut = "Space";
      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      shell = "${pkgs.fish}/bin/fish";
      mouse = true;
    };
    fish = {
      enable = true;
      plugins = [
        {
          name = "nix-env";
          src = pkgs.fetchFromGitHub {
            owner = "lilyball";
            repo = "nix-env.fish";
            rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
            sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
          };
        }
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "a959c8b97d5d444e1e1a04868967276acc127099";
            sha256 = "sha256-6T/4ThQ2KXrSnLBfCHF8PC3rg16D9cCUCvrS8RSvCno=";
          };
        }
        {
          name = "catppuccin";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "cb79527f5bd53f103719649d34eff3fbae634155";
            sha256 = "sha256-ciUNJrZE1EJ6YeMmEIjX/vDiP2MCG1AYHpdjeQOOSxg=";
          };
        }
        {
          name = "nvm";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "nvm.fish";
            rev = "9db8eaf6e3064a962bca398edd42162f65058ae8";
            sha256 = "sha256-LkCpij6i5XEkZGYLx9naO/cnbkUCuemypHwTjvfDzuk=";
          };
        }
        {
          name = "virtualfish";
          src = pkgs.fetchFromGitHub {
            owner = "justinmayer";
            repo = "virtualfish";
            rev = "e6163a009cad32feb02a55a631c66d1cc3f22eaa";
            sha256 = "sha256-u6wm+bWCkxxYbtb4wer0AGyVdvuaBiOH1nRmpZssVHo=";
            postFetch = ''
              mkdir $out/conf.d
              mv $out/virtualfish/*.fish $out/conf.d
            '';
          };
        }
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "fzf";
            rev = "479fa67d7439b23095e01b64987ae79a91a4e283";
            sha256 = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
          };
        }
      ];
      shellInit = ''
        # Set syntax highlighting colours; var names defined here:
        # http://fishshell.com/docs/current/index.html#variables-color
        set fish_color_autosuggestion brblack

        fish_config theme choose Nord
        set -Ux GIT_ASKPASS ""
        set VIRTUALFISH_PYTHON_EXEC $(which python)

        set -g direnv_fish_mode disable_arrow

        fish_add_path $HOME/.local/bin

        set -gx EDITOR nvim
        # The WAYLAND_DISPLAY env is not being set in terminals other than GNOME CONSOLE.
        # This was creating a problem when using helix, as it as not using wayland specific 
        # clipboard provider due to this.
        # This function is a workaround for setting the WAYLAND_DISPLAY env
        if not set -q "WAYLAND_DISPLAY"
          if set -q "XDG_SESSION_TYPE"
              echo "XDG_SESSION_TYPE is set"
              set SESSION_TYPE "$XDG_SESSION_TYPE"      

              if test "$SESSION_TYPE" = "wayland"
                  echo "Setting WAYLAND_DISPLAY to 'wayland-0'"
                  set -Ux WAYLAND_DISPLAY "wayland-0"
              else
                  echo "SESSION_TYPE is not 'wayland', exiting"
              end
          else
              echo "XDG_SESSION_TYPE is unset, exiting"
          end
        end
      '';
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";
        tmux = "tmux -u";
        ll = "eza -alhtaccessed";
      };
      shellAbbrs = {
        lg = "lazygit";
        ld = "lazydocker";
        g = "git";
        m = "make";
        n = "nvim";
        o = "open";
        p = "python3";
      };
      functions = {
        mkdcd = {
          description = "Make a directory tree and enter it";
          body = "mkdir -p $argv[1]; and cd $argv[1]";
        };
      };
    };
  };

  xdg.desktopEntries.ghostty = {
    name = "Ghostty";
    type = "Application";
    genericName = "Terminal";
    exec = "/home/mgr8/.local/bin/ghostty";
    icon = "Alacritty";
    categories = [
      "System"
      "TerminalEmulator"
    ];
    comment = "A terminal emulator";
  };

  home.file = {
    ".config/ghostty/config" = {
      text = ''
        font-family = JetBrainsMonoNL Nerd Font
        font-size = 15
        command = fish
      '';
    };
  };

  dconf.settings =
    let
      custom_shortcuts =
        let
          inherit (builtins) length head tail listToAttrs genList;
          range = a: b: if a < b then [ a ] ++ range (a + 1) b else [ ];
          globalPath = "org/gnome/settings-daemon/plugins/media-keys";
          path = "${globalPath}/custom-keybindings";
          mkPath = id: "${globalPath}/custom${toString id}";
          isEmpty = list: length list == 0;
          mkSettings = settings:
            let
              checkSettings = { name, command, binding }@this: this;
              aux = i: list:
                if isEmpty list then [ ] else
                let
                  hd = head list;
                  tl = tail list;
                  name = mkPath i;
                in
                aux (i + 1) tl ++ [{
                  name = mkPath i;
                  value = checkSettings hd;
                }];
              settingsList = (aux 0 settings);
            in
            listToAttrs (settingsList ++ [
              {
                name = globalPath;
                value = {
                  custom-keybindings = genList (i: "/${mkPath i}/") (length settingsList);
                };
              }
            ]);
        in
        mkSettings [
          {
            name = "Launch Ghostty";
            command = "/home/mgr8/.local/bin/ghostty";
            binding = "<Super>Return";
          }
          {
            name = "Launch Firefox";
            command = "firefox";
            binding = "<Super>b";
          }
        ];

      wm_keybinds = {
        "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          volume-down = [ "<Control><Alt>minus" "XF86AudioLowerVolume" ];
          volume-mute = [ "<Control><Alt>0" "XF86AudioMute" ];
          volume-up = [ "<Control><Alt>equal" "XF86AudioRaiseVolume" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Shift><Super>c" ];
          toggle-maximized = [ "<Super>m" ];
        };
      };

      app_menu_config = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
      };

      extensions = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "gnome-shell-screenshot@ttll.de" "clipboard-indicator@tudmotu.com" "appindicatorsupport@rgcjonas.gmail.com" ];
        };
      };
    in
    lib.mkMerge [ custom_shortcuts wm_keybinds extensions app_menu_config ];

}
