{ config, ... }:

{
  programs.fish.interactiveShellInit = ''
    # Reset binds
    bind -ea
    bind \c\et _fzf_search_directory

    bind \cf tmux-sessionizer
  '';
}
