#!/usr/bin/env bats

load fixture

@test "special exit status on bar drops that line once" {
    run -0 memoizeLines --drop-on 99 --command failOnBarTransformer <<'EOF'
first
foo
bar
foo
foobar
last
EOF
    assert_output - <<'EOF'
first
foo
foo
last
EOF
    assert_input $'first\nfoo\nbar\nfoobar\nlast'
}

@test "different exit status on stuff still aborts" {
    run -42 memoizeLines --drop-on 99 --command failOnBarTransformer --command 'sed "/stuff/q 42"' <<'EOF'
first
foo
bar
foo
stuff
last
EOF
    assert_output - <<'EOF'
first
foo
foo
EOF
    assert_input $'first\nfoo\nbar\nstuff'
}

@test "special exit status on bar is cached, too" {
    run -0 memoizeLines --drop-on 99 --command failOnBarTransformer <<'EOF'
first
foo
bar
foo
bar
foobar
foobar
last
EOF
    assert_output - <<'EOF'
first
foo
foo
last
EOF
    assert_input $'first\nfoo\nbar\nfoobar\nlast'
}
