function _fish_tmux_plugin_run_autostart --on-variable fish_tmux_autostart # https://github.com/P34R1/tmux.fish/blob/main/conf.d/tmux.fish
    if test "$fish_tmux_autostart" = true && test -z "$TMUX" && test -z "$INSIDE_EMACS" && test -z "$EMACS" && test -z "$NVIM" && test -z "$VSCODE_RESOLVING_ENVIRONMENT" && test "$TERM_PROGRAM" != vscode

        # tmux a          default   silent  if fail   new sesh named default    kill old fish (auto close when tmux closes)
        tmux -u attach -t default 2>/dev/null || tmux new-session -s default && kill $fish_pid
    end
end

set fish_tmux_autostart true
