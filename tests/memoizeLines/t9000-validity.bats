#!/usr/bin/env bats

load fixture
load interval

@test "cache stays valid by default" {
    runWithIntervalInput .5 $'foo\nfoo' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]" ]
    assert_input 'foo'
}

@test "two second delay invalidates cache" {
    runWithIntervalInput .5 $'foo\nfoo\nbar\nfoo\nfoo\n\nbar' memoizeLines --for 1s transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]
[foo]
[]
[bar]" ]
    assert_input $'foo\nbar\nfoo\n\nbar'
}
