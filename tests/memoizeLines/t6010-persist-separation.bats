#!/usr/bin/env bats

load persistence

@test "two different commands use different persistence" {
    run -0 memoizeLines --persist transformer <<<'foo'
    assert_output '[foo]'
    assert_input 'foo'

    clean_recorder
    run -0 memoizeLines --persist multiLineTransformer <<<'foo'
    assert_output - <<'EOF'
Start of foo:
  foo
---
EOF
    assert_input 'foo'

    clean_recorder
    run -0 memoizeLines --persist transformer <<<'foo'
    assert_output '[foo]'
    assert_input ''

    clean_recorder
    run -0 memoizeLines --persist multiLineTransformer <<<'foo'
    assert_output - <<'EOF'
Start of foo:
  foo
---
EOF
    assert_input ''
}

@test "the same command can use different persistence via id" {
    run -0 memoizeLines --persist --id ID1 transformer <<<'foo'
    assert_output '[foo]'
    assert_input 'foo'

    clean_recorder
    run -0 memoizeLines --persist --id ID2 transformer <<<'bar'
    assert_output '[bar]'
    assert_input 'bar'

    clean_recorder
    run -0 memoizeLines --persist --id ID1 transformer <<'EOF'
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[bar]
EOF
    assert_input 'bar'

    clean_recorder
    run -0 memoizeLines --persist --id ID2 transformer <<'EOF'
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[bar]
EOF
    assert_input 'foo'
}
