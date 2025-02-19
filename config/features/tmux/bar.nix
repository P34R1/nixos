{ config, ... }:

{
  hm.programs.tmux.extraConfig = ''
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

    # vim: set ft=tmux tw=0 nowrap:
  '';
}
