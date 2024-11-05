{ config, ... }:

{

  # \c for control
  # \e\c for ctrl + alt
  # i think shift is impossible

  hm.programs.fish.interactiveShellInit = ''
    # Reset binds
    bind -ea

    bind \ct _fzf_search_directory
    bind \cf tmux-sessionizer
    bind \e\cn "tmux-sessionizer ~/nixos"

    bind \cw "just watch"
  '';
}
