#!/usr/bin/env bats

load fixture

@test "transform via command-line" {
    run -0 memoizeLines --command "transformer | ${uppercaseCommand[*]}" <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[FIRST]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]
EOF
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "two separate command-lines are piped" {
    run -0 memoizeLines --command 'transformer' --command "${uppercaseCommand[*]}" <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[FIRST]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]
EOF
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "command-lines and simple command are piped" {
    run -0 memoizeLines --command 'transformer' --command "${firstToBeginCommand[*]}" -- "${uppercaseCommand[@]}" <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[BEGIN]
[FOO]
[FOO BAR]
[FOO]
[BAR]
[LAST]
EOF
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}
