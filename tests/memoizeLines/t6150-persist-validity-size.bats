#!/usr/bin/env bats

load persistence

@test "a simulated delay and eviction invalidate a size-limited persisted cache" {
    run -0 memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer <<'EOF'
foo
foo
bar
foo
more
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
[more]
EOF
    assert_input $'foo\nbar\nmore'

    clean_recorder
    run -0 memoizeLines --timestamp 1011 --size 2 --for 10s --persist transformer <<'EOF'
second
foo

bar
last
EOF
    assert_output - <<'EOF'
[second]
[foo]
[]
[bar]
[last]
EOF
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "a simulated delay invalidates a size-limited persisted cache" {
    run -0 memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer <<'EOF'
foo
foo
bar
foo
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
EOF
    assert_input $'foo\nbar'

    clean_recorder
    run -0 memoizeLines --timestamp 1011 --size 2 --for 10s --persist transformer <<'EOF'
second
foo

bar
last
EOF
    assert_output - <<'EOF'
[second]
[foo]
[]
[bar]
[last]
EOF
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "eviction invalidates a size-limited persisted cache after a simulated short delay" {
    run -0 memoizeLines --timestamp 1000 --size 2 --for 10s --persist transformer <<'EOF'
foo
foo
bar
foo
more
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
[more]
EOF
    assert_input $'foo\nbar\nmore'

    clean_recorder
    run -0 memoizeLines --timestamp 1006 --size 2 --for 10s --persist transformer <<'EOF'
second
foo

bar
last
EOF
    assert_output - <<'EOF'
[second]
[foo]
[]
[bar]
[last]
EOF
    assert_input $'second\nfoo\n\nbar\nlast'
}

@test "simulated delay and size limit partially invalidates a persisted cache" {
    run -0 memoizeLines --timestamp 1000 --size 4 --for 10s --persist transformer <<'EOF'
foo
bar
third
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[third]
EOF
    assert_input $'foo\nbar\nthird'

    clean_recorder
    run -0 memoizeLines --timestamp 1006 --size 4 --for 10s --persist transformer <<'EOF'
fourth
bar
third
fifth
EOF
    assert_output - <<'EOF'
[fourth]
[bar]
[third]
[fifth]
EOF
    assert_input $'fourth\nfifth'

    clean_recorder
    run -0 memoizeLines --timestamp 1012 --size 4 --for 10s --persist transformer <<'EOF'
foo
bar
fifth
foo
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[fifth]
[foo]
EOF
    assert_input $'foo\nbar'

    clean_recorder
    run -0 memoizeLines --timestamp 1012 --size 4 --for 10s --persist transformer <<'EOF'
bar
fifth
third
fourth
last
EOF
    assert_output - <<'EOF'
[bar]
[fifth]
[third]
[fourth]
[last]
EOF
    assert_input $'third\nfourth\nlast'
}
