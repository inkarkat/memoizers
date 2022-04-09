#!/usr/bin/env bats

export RECORD="${BATS_TMPDIR}/record"
setup()
{
    rm -f -- "$RECORD"
}
transformer()
{
    tee -a -- "$RECORD" | sed -e 's/.*/[&]/'
}
export -f transformer

dump_input()
{
    prefix '#' "$RECORD" >&3
}
assert_input()
{
    [ "$(cat -- "$RECORD")" = "${1?}" ]
}

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
    runWithInput 'first' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]" ]
}

@test "transform two unique lines" {
    runWithInput $'first\nsecond' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]
[second]" ]
    assert_input $'first\nsecond'
}

@test "transform two identical lines with single transformation" {
    runWithInput $'foo\nfoo\nbar' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]" ]
    assert_input $'foo\nbar'
}

@test "transform empty lines with single transformation" {
    runWithInput $'foo\n\n\nbar\n\nbaz' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[]
[]
[bar]
[]
[baz]" ]
    assert_input $'foo\n\nbar\nbaz'
}
