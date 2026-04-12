{ self, inputs, ... }:

{
  flake.nixosModules.fish =
    { pkgs, lib, ... }:
    {
      imports = with self.nixosModules; [
        fzf
        tmux
        yazi
      ];

      environment.systemPackages = with pkgs; [
        just
        entr
        bat
        eza
        jq
        fd
        ripgrep
        zoxide
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;

        settings = {
          hide_env_diff = true;
        };
      };

      programs.fish = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      };
    };

  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.fish = self.wrappers.fish.wrap (
        { config, ... }:
        let
          justfileRaw = builtins.readFile ./justfile;
          justfile = builtins.replaceStrings [ "\n" ] [ "\\n" ] justfileRaw;

          colorscripts = pkgs.fetchFromGitHub {
            owner = "P34R1";
            repo = "shell-colour-scripts";
            rev = "main";
            hash = "sha256-rkyIybfheDSLalTbbSte9KKehxSevxe+XI6I+b9loRY=";
          };

          # https://github.com/jorgebucaran/hydro
          hydro = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "hydro";
            rev = "main";
            sha256 = "sha256-Dfq974KpD1mtQKznIlkXfZfDnSF/4MfLTA18Ak0LADE=";
          };

          # https://github.com/PatrickF1/fzf.fish
          fzf = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "main";
            sha256 = "sha256-H7HgYT+okuVXo2SinrSs+hxAKCn4Q4su7oMbebKd/7s=";
          };
        in
        {
          inherit pkgs;

          # https://discourse.nixos.org/t/can-i-use-flakes-within-a-git-repo-without-committing-flake-nix/18196
          # https://discourse.nixos.org/t/adding-flake-nix-with-out-git-tracking-it/42806/2
          functions = ''
            function justfile
                set loc (git rev-parse --show-toplevel) # get root of project

                if test $status -ne 0
                    return 1
                end

                printf "justfile\n" >>$loc/.git/info/exclude # Ignore justfile
                if not [ -f "$loc/justfile" ]
                  printf '${justfile}' > $loc/justfile
                end

                set -e loc # remove env variable
            end

            function y
                set tmp (mktemp -t "yazi-cwd.XXXXXX")
                yazi $argv --cwd-file="$tmp"
                if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                    builtin cd -- "$cwd"
                end

                rm -f -- "$tmp"
            end

            function envrc
                set loc (git rev-parse --show-toplevel) # get root of project

                if test $status -ne 0
                    return 1
                end

                printf ".envrc" >>$loc/.git/info/exclude # Ignore flake and env

                if not [ -f "$loc/.envrc" ]
                    printf "use flake path:$loc" >$loc/.envrc
                end

                set -e loc # remove env variable
            end

            function fish_greeting
              set DIR_COLORSCRIPTS "${colorscripts}/colorscripts"
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
          '';

          # \c for control
          # \e\c for ctrl + alt
          # i think shift is impossible
          binds = ''
            bind \ct _fzf_search_directory
            bind \cf tmux-sessionizer
            bind \e\cn "tmux-sessionizer ~/nixos"
            bind \cw "just watch"
          '';

          # https://fishshell.com/docs/current/cmds/abbr.html
          abbrs = ''
            abbr -a -- nv nvim
            abbr -a -- ns nh os switch

            abbr -a -- g git
            abbr -a -- ga git add .
            abbr -a -- gd git diff
            abbr -a -- gdc git diff --cached
            abbr -a --set-cursor='|' -- gc 'git commit -m "|"'

            abbr -a -- l ls -al
            abbr -a -- tre ls --git-ignore -aT

            abbr -a -- ts tmux-sessionizer
            abbr -a -- tw tmux-windowizer

            alias ls eza
          '';

          interactiveShellInit = ''
            set fish_tmux_autostart true
            direnv hook fish | source
            zoxide init fish | source

            set --global fish_color_command blue
            set --global fish_color_quote yellow
          '';

          plugins = [
            hydro
            fzf
          ];
        }
      );
    };
}
