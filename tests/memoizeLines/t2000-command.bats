#!/usr/bin/env bats

inputWrapper()
{
    local input="$1"; shift
    printf '%s\n' "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}

@test "transform first line" {
    typeset -a transformer=(sed -e 's/.*/[&]/')
    runWithInput 'first' memoizeLines "${transformer[@]}"
    [ $status -eq 0 ]
    [ "$output" = "[first]" ]
}
