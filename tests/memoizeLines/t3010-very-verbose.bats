#!/usr/bin/env bats

load fixture

@test "very verbose run on input appends statistics" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --verbose --verbose transformer
    [ $status -eq 0 ]
    [ "$output" = 'memoizeLines: Cache miss for "first": [first]
[first]
memoizeLines: Cache miss for "foo": [foo]
[foo]
memoizeLines: Cache miss for "foo bar": [foo bar]
[foo bar]
memoizeLines: Cache hit for "foo": [foo]
[foo]
memoizeLines: Cache miss for "bar": [bar]
[bar]
memoizeLines: Cache miss for "last": [last]
[last]
memoizeLines: 6 lines, 1 cache hit (16%).' ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "very verbose command failing later appends statistics so far" {
    runWithInput $'first\nfoo\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines --verbose --verbose --command failOnBarTransformer
    [ $status -eq 99 ]
    [ "$output" = 'memoizeLines: Cache miss for "first": first
first
memoizeLines: Cache miss for "foo": foo
foo
memoizeLines: Cache hit for "foo": foo
foo
memoizeLines: Transformation failed for "foo bar" (99)
memoizeLines: 4 lines, 1 cache hit (25%).' ]
    assert_input $'first\nfoo\nfoo bar'
}
