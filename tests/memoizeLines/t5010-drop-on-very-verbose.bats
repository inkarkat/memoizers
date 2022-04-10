#!/usr/bin/env bats

load fixture

@test "very verbose special exit status on bar drops that line once" {
    runWithInput $'foo\nbar' memoizeLines --verbose --verbose --drop-on 99 --command failOnBarTransformer
    [ $status -eq 0 ]
    [ "$output" = 'memoizeLines: Cache miss for "foo": foo
foo
memoizeLines: Cache miss for "bar" (dropped input line)
memoizeLines: 2 lines, 0 cache hits (0%).' ]
    assert_input $'foo\nbar'
}
