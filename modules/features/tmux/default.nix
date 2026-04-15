{ self, inputs, ... }:

{

  flake.nixosModules.tmux =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.tmux;
    in
    {
      options.tmux = with lib; {
        reposPath = mkOption { type = types.str; };
      };

      config = {
        environment.systemPackages = [
          # https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
          # https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-windowizer
          # https://nixos.wiki/wiki/Shell_Scripts
          (pkgs.stdenv.mkDerivation {
            name = "tmux-scripts";

            src = builtins.path { path = ./.; };
            buildInputs = [ self.packages.${pkgs.stdenv.hostPlatform.system}.tmux ];

            installPhase = ''
              # Replace Variables
              sed -i "s|__REPOSITORY_PATHS__|${cfg.reposPath}|g" tmux-sessionizer

              # Setup Environment
              mkdir -p $out/bin
              cp tmux-* $out/bin
            '';

            meta = with pkgs.lib; {
              license = licenses.mit;
              platforms = platforms.linux;
            };
          })
        ];

        programs.tmux = {
          enable = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.tmux;
        };
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self,
      self',
      ...
    }:
    {
      packages.tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
        inherit pkgs;

        package = pkgs.tmux.override ({
          withSixel = true;
        });

        shell = "${lib.getExe self'.packages.fish}";
        terminal = "tmux-256color";
        mouse = true;
        prefix = "C-Space";

        configBefore = ''
          set -g allow-passthrough all
          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          bind-key -T prefix e command-prompt -I "#S" { rename-session '%%' }
          bind-key -T prefix r command-prompt -I "#W" { rename-window '%%' }

          # bar
          set-option -g status "on"
          set-option -g status-position "top"

          # default statusbar color
          set-option -g status-style "bg=default,fg=white"

          # pane border
          set-option -g pane-active-border-style "fg=white"
          set-option -g pane-border-style "fg=black"

          set-option -g message-style "bg=black,fg=yellow"
          set-option -g message-command-style "bg=black,fg=yellow"

          set-option -g status-justify "right"
          set-option -g status-left-style "fg=brightmagenta"
          set-option -g status-left " #S"
          set-option -g status-right ""
          set-option -g status-left-length 100 # Don't cut off name

          set-window-option -g window-status-current-style "fg=brightblue bold"
          set-window-option -g window-status-current-format " #I #W "

          set-window-option -g window-status-style "fg=brightmagenta bold"
          set-window-option -g window-status-format " #I #[fg=white]#W "
        '';
      };
    };
}
