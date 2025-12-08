#!/usr/bin/env bats

load fixture

@test "cache size 0 causes transformations for everything" {
    run -0 memoizeLines --size 0 transformer <<'EOF'
foo
foo
bar
foo
bar
bar
foo
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
[bar]
[bar]
[foo]
EOF
    assert_input $'foo\nfoo\nbar\nfoo\nbar\nbar\nfoo'
}

@test "cache size 1 only stores the last line" {
    run -0 memoizeLines --size 1 transformer <<'EOF'
foo
foo
bar
foo
bar
bar
foo
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
[bar]
[bar]
[foo]
EOF
    assert_input $'foo\nbar\nfoo\nbar\nfoo'
}

@test "cache size 2 stores the last two lines" {
    run -0 memoizeLines --size 2 transformer <<'EOF'
foo
foo
bar
bar
third
third
bar
foo
bar
third
foo
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
[foo]
[bar]
[third]
[foo]
[bar]
EOF
    assert_input $'foo\nbar\nthird\nfoo\nthird\nfoo\nbar'
}

@test "cache size 3 stores the last three lines" {
    run -0 memoizeLines --size 3 transformer <<'EOF'
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
[foo]
[foo]
[bar]
[bar]
[third]
[third]
[fourth]
[fifth]
[third]
[fourth]
[fifth]
[foo]
[fourth]
[third]
[foo]
[bar]
EOF
    assert_input $'foo\nbar\nthird\nfourth\nfifth\nfoo\nthird\nbar'
}
