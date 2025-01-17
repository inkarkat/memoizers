#!/usr/bin/env bats

load fixture

@test "immediately failing command exits with status and does not produce output" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command 'recorder | exit 42'
    [ $status -eq 42 ]
    [ "$output" = "" ]
    assert_input '' || assert_input 'first' # At most (depending on timing) the first line has been recorded.
}

@test "command failing later exits with status and aborts the output there" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command failOnBarTransformer
    [ $status -eq 99 ]
    [ "$output" = "first
foo" ]
    assert_input $'first\nfoo\nfoo bar'
}
