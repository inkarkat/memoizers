#!/usr/bin/env bats

load fixture

noInputWrapper()
{
    printf '' | "$@"
}

@test "verbose run on empty input just prints empty statistics" {
    run noInputWrapper memoizeLines --verbose --command 'recorder'
    [ $status -eq 0 ]
    [ "$output" = "memoizeLines: No lines." ]
    assert_input ''
}

@test "verbose run on input appends statistics" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --verbose transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]
[foo]
[foo bar]
[foo]
[bar]
[last]
memoizeLines: 6 lines, 1 cache hit (16%)." ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "verbose run on highly duplicate input appends statistics" {
    runWithInput $'first\nfoo\nfoo\nfoo\nbar\nbar\nfoo\nfoo\nbar\nlast' memoizeLines --verbose transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]
[foo]
[foo]
[foo]
[bar]
[bar]
[foo]
[foo]
[bar]
[last]
memoizeLines: 10 lines, 6 cache hits (60%)." ]
    assert_input $'first\nfoo\nbar\nlast'
}

@test "verbose run on completely identical input appends statistics" {
    runWithInput $'foo\nfoo\nfoo\nfoo' memoizeLines --verbose transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[foo]
[foo]
memoizeLines: 4 lines, 3 cache hits (75%)." ]
    assert_input 'foo'
}
