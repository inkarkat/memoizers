#!/usr/bin/env bats

load persistence

@test "verbose persisted transformations" {
    runWithInput $'foo\nbar\nthree\nbar\nlast' memoizeLines --verbose --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "memoizeLines: Starting with empty cache.
[foo]
[bar]
[three]
[bar]
[last]
memoizeLines: 5 lines, 1 cache hit (20%)." ]
    assert_input $'foo\nbar\nthree\nlast'

    clean_recorder
    runWithInput $'three\nbar\nfour\nfoo\nfive' memoizeLines --verbose --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "memoizeLines: Starting with 4 cached input lines
[three]
[bar]
[four]
[foo]
[five]
memoizeLines: 5 lines, 3 cache hits (60%)." ]
    assert_input $'four\nfive'
}
