#!/usr/bin/env bats

load fixture

@test "immediately failing command exits with status and does not produce output" {
    run -42 memoizeLines --command 'recorder | exit 42' <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output ''
    assert_input '' || assert_input 'first' # At most (depending on timing) the first line has been recorded.
}

@test "command failing later exits with status and aborts the output there" {
    run -99 memoizeLines --command failOnBarTransformer <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
first
foo
EOF
    assert_input $'first\nfoo\nfoo bar'
}
