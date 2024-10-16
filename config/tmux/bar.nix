{ config, ... }:

{
  programs.tmux.extraConfig = ''
    set-option -g status "on"
    set-option -g status-position "top"

    # default statusbar color
    set-option -g status-style bg=default,fg=white # bg=bg1, fg=fg1

    # default window title colors
    set-window-option -g window-status-style bg=yellow,fg=black # bg=yellow, fg=bg1

    # default window with an activity alert
    set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

    # active window title colors
    set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

    # pane border
    set-option -g pane-active-border-style fg=colour250 #fg2
    set-option -g pane-border-style fg=colour237 #bg1

    # message infos
    set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

    # writing commands inactive
    set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

    # pane number display
    set-option -g display-panes-active-colour colour250 #fg2
    set-option -g display-panes-colour colour237 #bg1

    ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
    set-option -g status-justify "right"
    set-option -g status-left-style none
    set-option -g status-left-length "80"
    set-option -g status-right-style none
    set-option -g status-right-length "80"
    set-window-option -g window-status-separator ""

    set-option -g status-left "#[fg=white,nobold,noitalics,nounderscore] #S"
    set-option -g status-right ""

    set-window-option -g window-status-current-format "#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,}"
    set-window-option -g window-status-format "#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223] #W"

    # vim: set ft=tmux tw=0 nowrap:
  '';
}
