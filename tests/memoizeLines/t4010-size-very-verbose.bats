#!/usr/bin/env bats

load fixture

@test "very verbose on cache size 3" {
    runWithInput $'foo\nfoo\nbar\nbar\nthird\nthird\nfourth\nfifth\nthird\nfourth\nfifth\nfoo\nfourth\nthird\nfoo\nbar' memoizeLines --verbose --verbose --size 3 transformer
    [ $status -eq 0 ]
    [ "$output" = 'memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Cache miss for "bar": [bar]
[bar]
memoizeLines: Cache hit for "bar": [bar]
[bar]
memoizeLines: Cache miss for "third": [third]
[third]
memoizeLines: Cache hit for "third": [third]
[third]
memoizeLines: Evicting "foo"
memoizeLines: Cache miss for "fourth": [fourth]
[fourth]
memoizeLines: Evicting "bar"
memoizeLines: Cache miss for "fifth": [fifth]
[fifth]
memoizeLines: Cache hit for "third": [third]
[third]
memoizeLines: Cache hit for "fourth": [fourth]
[fourth]
memoizeLines: Cache hit for "fifth": [fifth]
[fifth]
memoizeLines: Evicting "third"
memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: Cache hit for "fourth": [fourth]
[fourth]
memoizeLines: Evicting "fifth"
memoizeLines: Cache miss for "third": [third]
[third]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Evicting "fourth"
memoizeLines: Cache miss for "bar": [bar]
[bar]
memoizeLines: 16 lines, 8 cache hits (50%).' ]
}
