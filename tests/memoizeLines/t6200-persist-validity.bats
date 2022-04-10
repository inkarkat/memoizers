#!/usr/bin/env bats

load persistence

@test "a simulated delay smaller than the timeout works across a persisted cache" {
    runWithInput $'foo\nfoo\nbar\nfoo' memoizeLines --timestamp 1000 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]" ]
    assert_input $'foo\nbar'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1001 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\n\nlast'
}

@test "a simulated delay invalidates a persisted cache" {
    runWithInput $'foo\nfoo\nbar\nfoo' memoizeLines --timestamp 1000 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]" ]
    assert_input $'foo\nbar'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1011 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "a simulated delay partially invalidates a persisted cache" {
    runWithInput 'foo' memoizeLines --timestamp 1000 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input 'foo'

    clean_recorder
    runWithInput $'foo\nbar\nfoo' memoizeLines --timestamp 1006 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[foo]" ]
    assert_input 'bar'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1012 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\nfoo\n\nlast'
}
