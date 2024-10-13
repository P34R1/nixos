{ config, ... }:

{
  programs.fish.interactiveShellInit = ''
    # Reset binds
    bind -ea
    bind \cf _fzf_search_directory
  '';
}
