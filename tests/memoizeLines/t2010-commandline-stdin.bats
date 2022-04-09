#!/usr/bin/env bats

load fixture

@test "transform via command-line" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command "transformer | ${uppercaseCommand[*]}"
    [ $status -eq 0 ]
    [ "$output" = "[FIRST]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]" ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "two separate command-lines are piped" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command 'transformer' --command "${uppercaseCommand[*]}"
    [ $status -eq 0 ]
    [ "$output" = "[FIRST]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]" ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "command-lines and simple command are piped" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --command 'transformer' --command "${firstToBeginCommand[*]}" -- "${uppercaseCommand[@]}"
    [ $status -eq 0 ]
    [ "$output" = "[BEGIN]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]" ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}
