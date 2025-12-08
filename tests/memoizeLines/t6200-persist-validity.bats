#!/usr/bin/env bats

load persistence

@test "a simulated delay smaller than the timeout works across a persisted cache" {
    run -0 memoizeLines --timestamp 1000 --for 10s --persist transformer <<'EOF'
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
    run -0 memoizeLines --timestamp 1001 --for 10s --persist transformer <<'EOF'
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
    assert_input $'second\n\nlast'
}

@test "a simulated delay invalidates a persisted cache" {
    run -0 memoizeLines --timestamp 1000 --for 10s --persist transformer <<'EOF'
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
    run -0 memoizeLines --timestamp 1011 --for 10s --persist transformer <<'EOF'
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

@test "a simulated delay partially invalidates a persisted cache" {
    run -0 memoizeLines --timestamp 1000 --for 10s --persist transformer <<<'foo'
    assert_output '[foo]'
    assert_input 'foo'

    clean_recorder
    run -0 memoizeLines --timestamp 1006 --for 10s --persist transformer <<'EOF'
foo
bar
foo
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[foo]
EOF
    assert_input 'bar'

    clean_recorder
    run -0 memoizeLines --timestamp 1012 --for 10s --persist transformer <<'EOF'
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
    assert_input $'second\nfoo\n\nlast'
}
