#!/usr/bin/env bats

load fixture

@test "very verbose on cache size 3" {
    run -0 memoizeLines --verbose --verbose --size 3 transformer <<'EOF'
foo
foo
bar
bar
third
third
fourth
fifth
third
fourth
fifth
foo
fourth
third
foo
bar
EOF
    assert_output - <<'EOF'
memoizeLines: Cache miss for "foo": [foo]
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
memoizeLines: 16 lines, 8 cache hits (50%).
EOF
}
