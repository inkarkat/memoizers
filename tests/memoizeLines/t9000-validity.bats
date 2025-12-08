#!/usr/bin/env bats

load fixture
load delay

@test "cache stays valid by default" {
    runWithDelayInput -0 'foo' .5 'foo' -- memoizeLines transformer
    assert_output - <<'EOF'
[foo]
[foo]
EOF
    assert_input 'foo'
}

@test "a delay invalidates cache" {
    runWithDelayInput -0 $'foo\nfoo\nbar\nfoo' 2 $'foo\n\nbar' -- memoizeLines --for 1s transformer
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
[foo]
[foo]
[]
[bar]
EOF
    assert_input $'foo\nbar\nfoo\n\nbar'
}
