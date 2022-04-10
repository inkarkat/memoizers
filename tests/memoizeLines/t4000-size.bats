#!/usr/bin/env bats

load fixture

@test "cache size 1 only stores the last line" {
    runWithInput $'foo\nfoo\nbar\nfoo\nbar\nbar\nfoo' memoizeLines --size 1 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]
[bar]
[bar]
[foo]" ]
    assert_input $'foo\nbar\nfoo\nbar\nfoo'
}

@test "cache size 2 stores the last two lines" {
    runWithInput $'foo\nfoo\nbar\nbar\nthird\nthird\nbar\nfoo\nbar\nthird\nfoo\nbar' memoizeLines --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[bar]
[third]
[third]
[bar]
[foo]
[bar]
[third]
[foo]
[bar]" ]
    assert_input $'foo\nbar\nthird\nfoo\nthird\nfoo\nbar'
}

@test "cache size 3 stores the last three lines" {
    runWithInput $'foo\nfoo\nbar\nbar\nthird\nthird\nfourth\nfifth\nthird\nfourth\nfifth\nfoo\nfourth\nthird\nfoo\nbar' memoizeLines --size 3 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[bar]
[third]
[third]
[fourth]
[fifth]
[third]
[fourth]
[fifth]
[foo]
[fourth]
[third]
[foo]
[bar]" ]
    assert_input $'foo\nbar\nthird\nfourth\nfifth\nfoo\nthird\nbar'
}
