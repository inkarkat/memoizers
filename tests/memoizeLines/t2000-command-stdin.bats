#!/usr/bin/env bats

load fixture

@test "transform first line" {
    run -0 memoizeLines transformer <<<'first'
    assert_output '[first]'
}

@test "transform two unique lines" {
    run -0 memoizeLines transformer <<'EOF'
first
second
EOF
    assert_output - <<'EOF'
[first]
[second]
EOF
    assert_input $'first\nsecond'
}

@test "transform two identical lines with single transformation" {
    run -0 memoizeLines transformer <<'EOF'
foo
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[foo]
[bar]
EOF
    assert_input $'foo\nbar'
}

@test "transform empty lines with single transformation" {
    run -0 memoizeLines transformer <<'EOF'
foo


bar

baz
EOF
    assert_output - <<'EOF'
[foo]
[]
[]
[bar]
[]
[baz]
EOF
    assert_input $'foo\n\nbar\nbaz'
}

@test "transform to multiple lines" {
    run -0 memoizeLines multiLineTransformer <<'EOF'
foo
foo
bar
EOF
    assert_output - <<'EOF'
Start of foo:
  foo
---
Start of foo:
  foo
---
Start of bar:
  bar
---
EOF
    assert_input $'foo\nbar'
}

@test "transform to empty lines" {
    run -0 memoizeLines filterTransformer <<'EOF'
foo
foo
bar
EOF
    assert_output - <<'EOF'


[bar]
EOF
    assert_input $'foo\nbar'
}
