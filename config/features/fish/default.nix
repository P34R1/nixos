{ config, pkgs, lib, ... }:

{
  options = {
    fish.enable =
      lib.mkEnableOption "enable fish configuration";
  };

  imports = [
    ./keybinds.nix
  ];

  config = lib.mkIf config.fish.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fish.enable
    hm.programs.fish = {
      enable = true;

      # Completions
      # trash completions fish > ~/.config/fish/completions/trash.fish
      # nh completions --shell fish > ~/.config/fish/completions/nh.fish

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";

        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                  builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';

        # https://discourse.nixos.org/t/can-i-use-flakes-within-a-git-repo-without-committing-flake-nix/18196
        # https://discourse.nixos.org/t/adding-flake-nix-with-out-git-tracking-it/42806/2
        envrc = ''
          set loc (git rev-parse --show-toplevel) # get root of project
          printf ".direnv\n.envrc\nflake.nix\nflake.lock\n" >> $loc/.git/info/exclude # Ignore flake and env

          if not [ -f "$loc/.envrc" ]
            printf "use flake path:$loc" > $loc/.envrc
          end

          set -e loc # remove env variable
        '';
      };

      # https://fishshell.com/docs/current/cmds/abbr.html
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/fish.nix#L141
      # Line might change in the future
      # Find abbrModule = types.submodule {
      shellAbbrs = {
        rb = "nh os switch";

        ga = "git add .";
        gc = {
          expansion = "git commit -m \"|\"";
          setCursor = "|";
        };
        g = "git";

        gd = "git diff --cached";

        v = "nvim";
        l = "ls -al";

        ts = "tmux-sessionizer";
        tw = "tmux-windowizer";

        r = "projectdo -q run";
        b = "projectdo -q build";
        t = "projectdo -q test";
        p = "projectdo -q tool";
      };

      interactiveShellInit = ''
        function fish_greeting
          set DIR_COLORSCRIPTS "/home/pearl/.local/share/colorscripts"
          bash "$DIR_COLORSCRIPTS/$(basename (random choice $(ls $DIR_COLORSCRIPTS)))"
        end

        function _fish_tmux_plugin_run_autostart --on-variable fish_tmux_autostart # https://github.com/P34R1/tmux.fish/blob/main/conf.d/tmux.fish
          if test "$fish_tmux_autostart" = true && \
          test -z "$TMUX" && \
          test -z "$INSIDE_EMACS" && \
          test -z "$EMACS" && \
          test -z "$NVIM" && \
          test -z "$VSCODE_RESOLVING_ENVIRONMENT" && \
          test "$TERM_PROGRAM" != 'vscode'

            # tmux a          default   silent  if fail   new sesh named default    kill old fish (auto close when tmux closes)
            tmux -u attach -t default 2>/dev/null || tmux new-session -s default && kill $fish_pid
          end
        end

        set fish_tmux_autostart true

        direnv hook fish | source
        zoxide init fish | source
      '';


      plugins = [

        # https://github.com/meaningful-ooo/sponge
        {
          name = "sponge";
          src = pkgs.fetchFromGitHub {
            owner = "meaningful-ooo";
            repo = "sponge";
            rev = "main";
            sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
          };
        }

        # https://github.com/PatrickF1/fzf.fish
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "main";
            sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
          };
        }

        # https://github.com/jorgebucaran/hydro
        {
          name = "hydro";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "hydro";
            rev = "main";
            sha256 = "sha256-0MMiM0NRbjZPJLAMDXb+Frgm+du80XpAviPqkwoHjDA=";
          };
        }

      ];
    };
  };
}
