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
