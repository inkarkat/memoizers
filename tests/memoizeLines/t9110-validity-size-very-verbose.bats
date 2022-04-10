#!/usr/bin/env bats

load fixture
load delay

@test "very verbose outdated cache entries get removed before evicting valid ones" {
    runWithDelayInput foo 2 $'bar\nfoo' 1 $'third\nbar\nfoo' -- memoizeLines --verbose --verbose --for 2s --size 2 transformer
    [ $status -eq 0 ]
    [ "$output" = 'memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: Cache miss for "bar": [bar]
[bar]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Evicting outdated "foo"
memoizeLines: Cache miss for "third": [third]
[third]
memoizeLines: Cache hit for "bar": [bar]
[bar]
memoizeLines: Evicting "third"
memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: 6 lines, 2 cache hits (33%).' ]
}
