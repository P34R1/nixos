status is-interactive || exit

# function __jj_snapshot --on-event fish_preexec
#     command jj --at-op=@ --quiet util snapshot 2>/dev/null
# end

function fish_prompt
    jj --at-op=@ --quiet util snapshot 2>/dev/null

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
              ' 2>/dev/null | string split0)

    if test $status -ne 0
        echo -ns (set_color red) "[" (set_color yellow) (prompt_pwd) (set_color red) "]" (set_color normal) "\$ "
        return
    end

    set -l status_bookmark_info (jj --ignore-working-copy --at-op=@ --quiet --no-pager bookmark list -T '
                if(remote, separate("\0",
                  name,
                  coalesce(tracking_ahead_count.exact(), tracking_ahead_count.lower()),
                  coalesce(tracking_behind_count.exact(), tracking_behind_count.lower()),
                ))
              ' | string split0)

    # jj at
    set -l JJ_AT ""
    if test -n "$status_bookmark_info[1]"
        set JJ_AT $status_bookmark_info[1]

        set -l commits_ahead $status_bookmark_info[2]
        set -l commits_behind $status_bookmark_info[3]

        test "$commits_ahead" -ne 0; and set JJ_AT "$JJ_AT›$commits_ahead"
        test "$commits_behind" -ne 0; and set JJ_AT "$JJ_AT‹$commits_behind"
    end

    # jj_change
    set -l JJ_CHANGE "$status_log_info[1]"(set_color reset)"$status_log_info[2]"
    test -n "$status_log_info[5]"; and set JJ_CHANGE "$JJ_CHANGE "(set_color red)"$status_log_info[5]"

    # jj_desc
    set -l JJ_DESC "$status_log_info[3]"

    # jj_status
    set -l status_lines (string split \n -- $status_log_info[4])
    set -l status_a (string match 'A *' $status_lines | count)
    set -l status_d (string match 'D *' $status_lines | count)
    set -l status_m (string match 'M *' $status_lines | count)

    set -l JJ_STATUS ""
    test $status_a -ne 0; and set JJ_STATUS "$JJ_STATUS "(set_color  green)"+$status_a"
    test $status_d -ne 0; and set JJ_STATUS "$JJ_STATUS "(set_color    red)"-$status_d"
    test $status_m -ne 0; and set JJ_STATUS "$JJ_STATUS "(set_color yellow)"^$status_m"
    set JJ_STATUS "$JJ_STATUS"(set_color normal)

    # print
    set -l JJ_PROMPT (string join " " -- (set_color magenta)$JJ_AT $JJ_CHANGE (set_color blue)$JJ_DESC$JJ_STATUS)
    echo -ns (set_color red) "[" (set_color yellow) (prompt_pwd) (set_color red) " | " $JJ_PROMPT (set_color red) "]" (set_color normal) "\$ "
end
