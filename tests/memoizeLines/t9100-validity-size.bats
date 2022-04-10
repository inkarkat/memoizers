#!/usr/bin/env bats

load fixture
load delay

@test "outdated cache entries get removed before evicting valid ones" {
    runWithDelayInput foo 2 $'bar\nfoo' 1 $'third\nbar\nfoo' -- memoizeLines --for 2s --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]
[foo]
[third]
[bar]
[foo]" ]
    assert_input $'foo\nbar\nthird\nfoo'
}
