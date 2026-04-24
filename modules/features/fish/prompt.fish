status is-interactive || exit

# redraw prompt when _jj_prompt changes
set --global _jj_prompt _jj_prompt_$fish_pid
function $_jj_prompt --on-variable $_jj_prompt
    commandline --function repaint
end

# background
function _jj_prompt_trigger --on-event fish_prompt
    if set -q _jj_prompt_last_pid
        kill $_jj_prompt_last_pid 2>/dev/null # avoid race condition
    end

    # background process
    fish --private --command "
      $(functions _jj_prompt_render)
      _jj_prompt_render $_jj_prompt
    " &
    set --global _jj_prompt_last_pid $last_pid
end

function fish_prompt
    set -l last_status $status

    set -l HN_PROMPT ""
    test -n "$SSH_CLIENT"; and set HN_PROMPT (set_color blue)$hostname(set_color red)" | "

    set -l JJ_PROMPT ""
    test -n "$$_jj_prompt"; and set JJ_PROMPT (set_color red)" | "$$_jj_prompt

    set -l ST_PROMPT ""
    test "$last_status" -ne 0; and set ST_PROMPT (set_color red)" ["$last_status"]"

    echo -ns (set_color red)"[" $HN_PROMPT (set_color yellow)(prompt_pwd) $JJ_PROMPT (set_color red)"]" $ST_PROMPT (set_color normal)"\$ "
end

function _jj_prompt_exit --on-event fish_exit
    set --erase $_jj_prompt
end

function _jj_prompt_render -a prompt_ref
    # snapshot and early return if not in jj repo
    jj --at-op=@ --quiet util snapshot 2>/dev/null
    if test $status -ne 0
        set --universal $prompt_ref ""
        return
    end

    # fetch jj info
    set -l log (jj --ignore-working-copy --at-op=@ --quiet --no-pager log --no-graph --limit 1 -r @ -T '
          separate("\0",
            change_id.shortest(4).prefix(),
            change_id.shortest(4).rest(),
            coalesce(description.first_line(), "󰏫"),
            coalesce(diff.summary(), "null"),
            concat(
              if(conflict, "💥"),
              if(divergent, "🚧"),
              if(hidden, "👻"),
              if(immutable, "🔒"),
            ),
          )
        ' | string split0)

    set -l bookmark (jj --ignore-working-copy --at-op=@ --quiet --no-pager bookmark list -T '
          if(remote, separate("\0",
            name,
            coalesce(tracking_ahead_count.exact(), tracking_ahead_count.lower()),
            coalesce(tracking_behind_count.exact(), tracking_behind_count.lower()),
          ))
        ' | string split0)

    # jj at (bookmark info and change id)
    set -l JJ_AT ""
    if test -n "$bookmark[1]"
        set JJ_AT $bookmark[1]

        set -l commits_ahead $bookmark[2]
        set -l commits_behind $bookmark[3]

        test "$commits_ahead" -ne 0; and set JJ_AT "$JJ_AT›$commits_ahead"
        test "$commits_behind" -ne 0; and set JJ_AT "$JJ_AT‹$commits_behind"
        set JJ_AT "$JJ_AT "
    end

    set JJ_AT "$JJ_AT$log[1]"(set_color reset)"$log[2]"
    test -n "$log[5]"; and set JJ_AT "$JJ_AT "(set_color red)"$log[5]"

    # jj_desc (description)
    set -l JJ_DESC "$log[3]"

    # jj_diff (difference)
    set -l JJ_DIFF ""

    set -l diff 0 0 0
    for line in (string split \n -- $log[4])
        switch $line
            case "A *"
                set diff[1] (math $diff[1] + 1)
            case "D *"
                set diff[2] (math $diff[2] + 1)
            case "M *"
                set diff[3] (math $diff[3] + 1)
        end
    end

    test $diff[1] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color  green)"+$diff[1]"
    test $diff[2] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color    red)"-$diff[2]"
    test $diff[3] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color yellow)"^$diff[3]"

    set --universal $prompt_ref (string join " " -- (set_color magenta)$JJ_AT (set_color blue)$JJ_DESC$JJ_DIFF)
end
