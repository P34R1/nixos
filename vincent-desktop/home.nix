{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    # Spicetify
    inputs.spicetify-nix.homeManagerModules.default

    # Nix Colors  
    # inputs.nix-colors.homeManagerModules.default
  ];

  # https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
  #colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  colorScheme = import ./gruvbox.nix;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable
  programs.fd.enable = true;
  programs.fd.ignores = [ ".git/" ];

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
  programs.bat.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
  programs.eza.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
  programs.fzf = {
    enable = true;

    defaultCommand = "fd --color=always";

    # https://github.com/PatrickF1/fzf.fish/blob/main/functions/_fzf_wrapper.fish
    defaultOptions = [
      "--cycle" # allows jumping between the first and last results, making scrolling faster
      "--layout=reverse" # lists results top to bottom, mimicking the familiar layouts of git log, history, and env
      "--border" # shows where the fzf window begins and ends
      "--height=90%" # leaves space to see the current command and some scrollback, maintaining context of work
      "--preview-window=wrap" # wraps long lines in the preview window, making reading easier
      "--marker=\"*\"" # makes the multi-select marker more distinguishable from the pointer (since both default to >)
      "--ansi" # enable ansi color code parsing
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jq.enable
  programs.jq.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable
  programs.ripgrep.enable = true;

  programs.neovim = {
    enable = true;
    extraPackages = [ pkgs.gcc ];
  };

  programs.direnv = {
    enable = true;

    config = {
      hide_env_diff = true;
    };
  };

  programs.zoxide.enable = true;
  programs.zoxide.options = [];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  # Home Manager Config.
  home.username = "pearl";
  home.homeDirectory = "/home/pearl";

  home.stateVersion = "24.05"; # Don't Change.

  home.file = {
    ".local/share/colorscripts/".source = config.lib.file.mkOutOfStoreSymlink /home/pearl/repos/shell-color-scripts/colorscripts;
    ".local/share/wall.png".source = config.lib.file.mkOutOfStoreSymlink /home/pearl/backgrounds/nix-wallpaper-simple-blue.png;

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink /home/pearl/repos/nvim;
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
