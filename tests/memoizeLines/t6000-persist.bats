#!/usr/bin/env bats

load persistence

@test "a single persisted transformation is reused by a second invocation" {
    run -0 memoizeLines --persist transformer <<<'foo'
    assert_output '[foo]'
    assert_input 'foo'

    clean_recorder
    run -0 memoizeLines --persist transformer <<<'foo'
    assert_output '[foo]'
    assert_input ''
}

@test "persisted transformations are reused by a second invocation" {
    run -0 memoizeLines --persist transformer <<'EOF'
foo
bar
three
bar
last
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[three]
[bar]
[last]
EOF
    assert_input $'foo\nbar\nthree\nlast'

    clean_recorder
    run -0 memoizeLines --persist transformer <<'EOF'
three
bar
four
foo
five
EOF
    assert_output - <<'EOF'
[three]
[bar]
[four]
[foo]
[five]
EOF
    assert_input $'four\nfive'
}
