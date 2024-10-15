{ config, ... }:

{

  # \c for control
  # \e\c for ctrl + alt
  # i think shift is impossible

  programs.fish.interactiveShellInit = ''
    # Reset binds
    bind -ea

    bind \ct _fzf_search_directory
    bind \cf tmux-sessionizer
  '';
}
