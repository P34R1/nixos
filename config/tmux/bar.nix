{ config, ... }:

{
  programs.tmux.extraConfig = ''
    set-option -g status "on"
    set-option -g status-position "top"

    # default statusbar color
    set-option -g status-style bg=default,fg=white

    # default window with an activity alert
    set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

    # pane border
    set-option -g pane-active-border-style fg=white
    set-option -g pane-border-style fg=black

    # message infos
    set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

    # writing commands inactive
    set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

    ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
    set-option -g status-justify "right"

    set-option -g status-left-style "fg=brightmagenta"
    set-option -g status-left " #S"
    set-option -g status-right ""

    set-window-option -g window-status-current-style "fg=brightblue bold"
    set-window-option -g window-status-current-format " #I #W "

    set-window-option -g window-status-style "fg=brightmagenta bold"
    set-window-option -g window-status-format " #I #[fg=white]#W "

    # vim: set ft=tmux tw=0 nowrap:
  '';
}