#!/usr/bin/env bats

load fixture
load delay

@test "very verbose outdated cache entries get removed before evicting valid ones" {
    runWithDelayInput -0 foo 2 $'bar\nfoo' 1 $'third\nbar\nfoo' -- memoizeLines --verbose --verbose --for 2s --size 2 transformer
    assert_output -e - <<'EOF'
^memoizeLines: Cache miss for "foo": \[foo\]
\[foo\]
memoizeLines: Cache miss for "bar": \[bar\]
\[bar\]
memoizeLines: Cache hit for "foo"; last update was 2 seconds ago: \[foo\]
\[foo\]
memoizeLines: Evicting outdated "foo"; last update was 3 seconds ago.
memoizeLines: Cache miss for "third"; last update was 1 second ago: \[third\]
\[third\]
memoizeLines: Cache hit for "bar"; last update was (1 second|2 seconds) ago: \[bar\]
\[bar\]
memoizeLines: Evicting "third"
memoizeLines: Cache miss for "foo"; last update was (just now|1 second ago): \[foo\]
\[foo\]
memoizeLines: 6 lines, 2 cache hits \(33%\).$
EOF
}
