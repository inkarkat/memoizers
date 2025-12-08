#!/usr/bin/env bats

load persistence

@test "verbose persisted transformations" {
    run -0 memoizeLines --verbose --persist transformer <<'EOF'
foo
bar
three
bar
last
EOF
    assert_output - <<'EOF'
memoizeLines: Starting with empty cache.
[foo]
[bar]
[three]
[bar]
[last]
memoizeLines: 5 lines, 1 cache hit (20%).
EOF
    assert_input $'foo\nbar\nthree\nlast'

    clean_recorder
    run -0 memoizeLines --verbose --persist transformer <<'EOF'
three
bar
four
foo
five
EOF
    assert_output - <<'EOF'
memoizeLines: Starting with 4 cached input lines
[three]
[bar]
[four]
[foo]
[five]
memoizeLines: 5 lines, 3 cache hits (60%).
EOF
    assert_input $'four\nfive'
}
