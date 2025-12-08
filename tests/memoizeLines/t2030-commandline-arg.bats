#!/usr/bin/env bats

load fixture

@test "transform via plain argument to command-line" {
    run -0 memoizeLines --command 'argTransformer {}' <<'EOF'
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
EOF
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "transform via embellished argument to command" {
    run -0 memoizeLines --command "argTransformer arg:{}" <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[arg:first]
[arg:foo]
[arg:foo bar]
[arg:foo]
[arg:bar]
[arg:last]
EOF
    assert_input $'arg:first\narg:foo\narg:foo bar\narg:bar\narg:last'
}

@test "transform via duplicated argument to command" {
    run -0 memoizeLines --command "argTransformer B{}-{}E" <<'EOF'
first
foo
foo bar
foo
bar
last
EOF
    assert_output - <<'EOF'
[Bfirst-firstE]
[Bfoo-fooE]
[Bfoo bar-foo barE]
[Bfoo-fooE]
[Bbar-barE]
[Blast-lastE]
EOF
    assert_input "Bfirst-firstE
Bfoo-fooE
Bfoo bar-foo barE
Bbar-barE
Blast-lastE"
}
