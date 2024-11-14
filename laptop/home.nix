{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
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

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  home.file = {
    ".local/share/colorscripts/".source = config.lib.file.mkOutOfStoreSymlink /home/pearl/repos/shell-color-scripts/colorscripts;
    ".local/share/wall.png".source = config.lib.file.mkOutOfStoreSymlink /home/pearl/backgrounds/nix-wallpaper-simple-blue.png;
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };
}
