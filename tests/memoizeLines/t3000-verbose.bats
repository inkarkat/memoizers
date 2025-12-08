#!/usr/bin/env bats

load fixture

@test "verbose run on empty input just prints empty statistics" {
    run -0 memoizeLines --verbose --command 'recorder' < /dev/null
    assert_output 'memoizeLines: No lines.'
    assert_input ''
}

@test "verbose run on input appends statistics" {
    run -0 memoizeLines --verbose transformer <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[first]
[foo]
[foo bar]
[foo]
[bar]
[last]
memoizeLines: 6 lines, 1 cache hit (16%).
EOF
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "verbose run on highly duplicate input appends statistics" {
    run -0 memoizeLines --verbose transformer <<'EOF'
first
foo
foo
foo
bar
bar
foo
foo
bar
last
EOF
    assert_output - <<'EOF'
[first]
[foo]
[foo]
[foo]
[bar]
[bar]
[foo]
[foo]
[bar]
[last]
memoizeLines: 10 lines, 6 cache hits (60%).
EOF
    assert_input $'first\nfoo\nbar\nlast'
}

@test "verbose run on completely identical input appends statistics" {
    run -0 memoizeLines --verbose transformer <<'EOF'
foo
foo
foo
foo
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[foo]
[foo]
memoizeLines: 4 lines, 3 cache hits (75%).
EOF
    assert_input 'foo'
}

@test "verbose command failing later appends statistics so far" {
    run -99 memoizeLines --verbose --command failOnBarTransformer <<'EOF'
first
foo
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
first
foo
foo
memoizeLines: 4 lines, 1 cache hit (25%).
EOF
    assert_input $'first\nfoo\nfoo bar'
}
