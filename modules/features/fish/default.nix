{ self, inputs, ... }:

{
  flake.nixosModules.fish =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = with self.nixosModules; [
        fzf
        yazi
      ];

      environment.systemPackages =
        with pkgs;
        let
          justfileRaw = builtins.readFile ./justfile;
          justfile = builtins.replaceStrings [ "\n" ] [ "\\n" ] justfileRaw;
        in
        [
          just
          entr
          bat
          eza
          jq
          fd
          ripgrep
          zoxide
          tlrc
          trashy

          (writeShellScriptBin "justfile" ''
            loc=$(git rev-parse --show-toplevel) || exit 1

            printf "justfile\n" >> "$loc/.git/info/exclude"
            if [ ! -f "$loc/justfile" ]; then
              printf "${justfile}" > "$loc/justfile"
            fi
          '')

          (writeShellScriptBin "envrc" ''
            loc=$(git rev-parse --show-toplevel) || exit 1

            printf ".envrc\n" >> "$loc/.git/info/exclude"
            if [ ! -f "$loc/.envrc" ]; then
              printf "use flake path:$loc" > "$loc/.envrc"
            fi
          '')
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
          # https://github.com/P34R1/shell-colour-scripts
          colorscripts = pkgs.fetchFromGitHub {
            owner = "P34R1";
            repo = "shell-colour-scripts";
            rev = "main";
            hash = "sha256-rkyIybfheDSLalTbbSte9KKehxSevxe+XI6I+b9loRY=";
          };
        in
        {
          config = {
            inherit pkgs;

            functions = ''
              function y
                  set tmp (mktemp -t "yazi-cwd.XXXXXX")
                  yazi $argv --cwd-file="$tmp"
                  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                      builtin cd -- "$cwd"
                  end

                  rm -f -- "$tmp"
              end

              function fish_greeting
                set DIR_COLORSCRIPTS "${colorscripts}/colorscripts"
                bash "$DIR_COLORSCRIPTS/$(basename (random choice $(ls $DIR_COLORSCRIPTS)))"
              end
            '';

            # https://fishshell.com/docs/current/cmds/bind.html
            binds = ''
              bind ctrl-w "just watch"
            '';

            # https://fishshell.com/docs/current/cmds/abbr.html
            abbrs = ''
              abbr -a -- nv nvim
              abbr -a -- ns nh os switch

              abbr -a --set-cursor='|' -- jjd 'jj desc -m "|"'
              abbr -a --set-cursor='|' -- jjc 'jj ci -m "|"'
              abbr -a --set-cursor='|' -- jjn 'jj new -m "|"'

              abbr -a -- l ls -al
              abbr -a -- tre ls --git-ignore -aT

              alias ls eza
              alias r trashy
            '';

            interactiveShellInit = ''
              source ${./prompt.fish}
              direnv hook fish | source
              zoxide init fish | source

              set --global fish_color_command blue
              set --global fish_color_quote yellow
            '';
          };
        }
      );
    };
}
