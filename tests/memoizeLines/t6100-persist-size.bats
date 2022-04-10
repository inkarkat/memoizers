#!/usr/bin/env bats

load persistence

@test "persisted cache size 2" {
    runWithInput $'foo\nfoo\nbar\nbar\nthird\nthird\nbar' memoizeLines --persist --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[bar]
[third]
[third]
[bar]" ]
    assert_input $'foo\nbar\nthird'

    clean_recorder
    runWithInput $'foo\nbar\nthird\nfoo\nbar' memoizeLines --persist --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[third]
[foo]
[bar]" ]
    assert_input $'foo\nthird\nfoo\nbar'
}

@test "larger persisted cache of size 3 gets loaded with size 2 restriction" {
    runWithInput $'foo\nfoo\nbar\nbar\nthird\nthird\nbar' memoizeLines --persist --size 3 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[bar]
[third]
[third]
[bar]" ]
    assert_input $'foo\nbar\nthird'

    clean_recorder
    runWithInput $'foo\nbar\nthird\nfoo\nbar' memoizeLines --persist --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[third]
[foo]
[bar]" ]
    assert_input $'foo\nthird\nfoo\nbar'
}
