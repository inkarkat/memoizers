#!/usr/bin/env bats

load fixture
load delay

@test "very verbose delay invalidates cache" {
    runWithDelayInput $'foo\nfoo\nbar\nfoo' 2 $'foo\n\nbar' -- memoizeLines --verbose --verbose --for 1s transformer
    [ $status -eq 0 ]
    [ "$output" = 'memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Cache miss for "bar": [bar]
[bar]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Outdated cache entry for "foo": [foo]
[foo]
memoizeLines: Cache miss for "": []
[]
memoizeLines: Outdated cache entry for "bar": [bar]
[bar]
memoizeLines: 7 lines, 2 cache hits (28%).' ]
}
