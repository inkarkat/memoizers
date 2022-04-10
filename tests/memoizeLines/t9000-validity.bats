#!/usr/bin/env bats

load fixture
load delay

@test "cache stays valid by default" {
    runWithDelayInput 'foo' .5 'foo' -- memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]" ]
    assert_input 'foo'
}

@test "a delay invalidates cache" {
    runWithDelayInput $'foo\nfoo\nbar\nfoo' 2 $'foo\n\nbar' -- memoizeLines --for 1s transformer
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
