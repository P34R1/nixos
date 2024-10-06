{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    # Spicetify
    inputs.spicetify-nix.homeManagerModules.default

    # Nix Colors  
    inputs.nix-colors.homeManagerModules.default

    ../config/hypr/hyprland.nix
    ../config/dunst.nix
    ../config/git.nix
    ../config/spicetify.nix
    ../config/foot.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  # Home Manager Config.
  home.username = "pearl";
  home.homeDirectory = "/home/pearl";

  home.stateVersion = "24.05"; # Don't Change.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".xinitrc".source = ../dotfiles/xinitrc;

    ".config/lf/".source = ../dotfiles/lf;
    ".config/lf/".recursive = true;

#    ".config/hypr/" = {
#      source = ../dotfiles/hypr;
#      recursive = true;
#    };

    ".config/tofi/config".source = ../dotfiles/tofi;

    ".local/share/icons/dunst/".source = ../config/dunsticons;
    ".local/share/icons/dunst/".recursive = true;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pearl/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

#  qt = {
#    enable = true;
#    platformTheme = "gnome";
#    style = "adwaita-dark";
#  };
}
