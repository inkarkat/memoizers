#!/usr/bin/env bats

load persistence

@test "a simulated delay and eviction invalidate a size-limited persisted cache" {
    runWithInput $'foo\nfoo\nbar\nfoo\nmore' memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]
[more]" ]
    assert_input $'foo\nbar\nmore'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1011 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "a simulated delay invalidates a size-limited persisted cache" {
    runWithInput $'foo\nfoo\nbar\nfoo' memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]" ]
    assert_input $'foo\nbar'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1011 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "eviction invalidates a size-limited persisted cache after a simulated short delay" {
    runWithInput $'foo\nfoo\nbar\nfoo\nmore' memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]
[more]" ]
    assert_input $'foo\nbar\nmore'

    clean_recorder
    runWithInput $'second\nfoo\n\nbar\nlast' memoizeLines --timestamp 1006 --size 2 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[second]
[foo]
[]
[bar]
[last]" ]
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "simulated delay and size limit partially invalidates a persisted cache" {
    runWithInput $'foo\nbar\nthird' memoizeLines --timestamp 1000 --size 4 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[third]" ]
    assert_input $'foo\nbar\nthird'

    clean_recorder
    runWithInput $'fourth\nbar\nthird\nfifth' memoizeLines --timestamp 1006 --size 4 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[fourth]
[bar]
[third]
[fifth]" ]
    assert_input $'fourth\nfifth'

    clean_recorder
    runWithInput $'foo\nbar\nfifth\nfoo' memoizeLines --timestamp 1012 --size 4 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[fifth]
[foo]" ]
    assert_input $'foo\nbar'

    clean_recorder
    runWithInput $'bar\nfifth\nthird\nfourth\nlast' memoizeLines --timestamp 1012 --size 4 --for 10s --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[bar]
[fifth]
[third]
[fourth]
[last]" ]
    assert_input $'third\nfourth\nlast'
}
