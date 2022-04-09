#!/usr/bin/env bats

load fixture

@test "immediately failing command exits with status and does not produce output" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command 'recorder | exit 42'
    [ $status -eq 42 ]
    [ "$output" = "" ]
    assert_input ''
}

@test "command failing later exits with status and aborts the output there" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command 'recorder | sed -e "/bar/q 99"'
    [ $status -eq 99 ]
    [ "$output" = "first
foo" ]
    assert_input $'first\nfoo\nfoo bar'
}
