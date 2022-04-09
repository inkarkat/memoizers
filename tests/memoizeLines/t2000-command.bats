#!/usr/bin/env bats

export transformer=(sed -e 's/.*/[&]/')

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
    runWithInput 'first' memoizeLines "${transformer[@]}"
    [ $status -eq 0 ]
    [ "$output" = "[first]" ]
}

@test "transform two unique lines" {
    runWithInput $'first\nsecond' memoizeLines "${transformer[@]}"
    [ $status -eq 0 ]
    [ "$output" = "[first]
[second]" ]
}
