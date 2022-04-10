#!/usr/bin/env bats

load persistence

@test "a single persisted transformation is reused by a second invocation" {
    runWithInput 'foo' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input 'foo'

    clean_recorder
    runWithInput 'foo' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input ''
}

@test "persisted transformations are reused by a second invocation" {
    runWithInput $'foo\nbar\nthree\nbar\nlast' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[three]
[bar]
[last]" ]
    assert_input $'foo\nbar\nthree\nlast'

    clean_recorder
    runWithInput $'three\nbar\nfour\nfoo\nfive' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[three]
[bar]
[four]
[foo]
[five]" ]
    assert_input $'four\nfive'
}
