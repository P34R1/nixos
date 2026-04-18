status is-interactive || exit

function fish_prompt
    # snapshot and early return if not in jj repo
    jj --at-op=@ --quiet util snapshot 2>/dev/null
    if test $status -ne 0
        echo -ns (set_color red) "[" (set_color yellow) (prompt_pwd) (set_color red) "]" (set_color normal) "\$ "
        return
    end
  
    # fetch jj info
    set -l status_log_info (jj --ignore-working-copy --at-op=@ --quiet --no-pager log --no-graph --limit 1 -r @ -T '
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

    set -l status_bookmark_info (jj --ignore-working-copy --at-op=@ --quiet --no-pager bookmark list -T '
                if(remote, separate("\0",
                  name,
                  coalesce(tracking_ahead_count.exact(), tracking_ahead_count.lower()),
                  coalesce(tracking_behind_count.exact(), tracking_behind_count.lower()),
                ))
              ' | string split0)

    # jj at (bookmark info and change id)
    set -l JJ_AT ""
    if test -n "$status_bookmark_info[1]"
        set JJ_AT $status_bookmark_info[1]

        set -l commits_ahead $status_bookmark_info[2]
        set -l commits_behind $status_bookmark_info[3]

        test "$commits_ahead" -ne 0; and set JJ_AT "$JJ_AT›$commits_ahead"
        test "$commits_behind" -ne 0; and set JJ_AT "$JJ_AT‹$commits_behind"
        set JJ_AT "$JJ_AT "
    end

    set JJ_AT "$JJ_AT$status_log_info[1]"(set_color reset)"$status_log_info[2]"
    test -n "$status_log_info[5]"; and set JJ_AT "$JJ_AT "(set_color red)"$status_log_info[5]"

    # jj_desc (description)
    set -l JJ_DESC "$status_log_info[3]"

    # jj_diff (difference)
    set -l JJ_DIFF ""

    set -l diff 0 0 0
    for line in (string split \n -- $status_log_info[4])
        switch $line
            case 'A *'; set diff[1] (math $diff[1] + 1)
            case 'D *'; set diff[2] (math $diff[2] + 1)
            case 'M *'; set diff[3] (math $diff[3] + 1)
        end
    end

    test $diff[1] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color  green)"+$diff[1]"
    test $diff[2] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color    red)"-$diff[2]"
    test $diff[3] -ne 0; and set JJ_DIFF "$JJ_DIFF "(set_color yellow)"^$diff[3]"

    # print
    set -l JJ_PROMPT (string join " " -- (set_color magenta)$JJ_AT (set_color blue)$JJ_DESC$JJ_DIFF)
    echo -ns (set_color red) "[" (set_color yellow) (prompt_pwd) (set_color red) " | " $JJ_PROMPT (set_color red) "]" (set_color normal) "\$ "
end
