{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./bar.nix
  ];

  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.tmux.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tmux.enable
    hm.programs.tmux = {
      enable = true;

      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/misc/tmux/default.nix
      package = pkgs.tmux.override ({
        withSixel = true;
      });

      shell = "${pkgs.fish}/bin/fish";
      terminal = "tmux-256color";
      mouse = true;
      prefix = "C-Space";
      baseIndex = 1;
      escapeTime = 10;

      extraConfig = ''
        set -g allow-passthrough all
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM

        bind-key -T prefix e command-prompt -I "#S" { rename-session '%%' }
        bind-key -T prefix r command-prompt -I "#W" { rename-window '%%' }
      '';
    };
  };
}
