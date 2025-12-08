#!/usr/bin/env bats

load persistence

@test "persisted cache size 2" {
    run -0 memoizeLines --persist --size 2 transformer <<'EOF'
foo
foo
bar
bar
third
third
bar
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[bar]
[third]
[third]
[bar]
EOF
    assert_input $'foo\nbar\nthird'

    clean_recorder
    run -0 memoizeLines --persist --size 2 transformer <<'EOF'
foo
bar
third
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[third]
[foo]
[bar]
EOF
    assert_input $'foo\nthird\nfoo\nbar'
}

@test "larger persisted cache of size 3 gets loaded with size 2 restriction" {
    run -0 memoizeLines --persist --size 3 transformer <<'EOF'
foo
foo
bar
bar
third
third
bar
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[bar]
[third]
[third]
[bar]
EOF
    assert_input $'foo\nbar\nthird'

    clean_recorder
    run -0 memoizeLines --persist --size 2 transformer <<'EOF'
foo
bar
third
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[third]
[foo]
[bar]
EOF
    assert_input $'foo\nthird\nfoo\nbar'
}
