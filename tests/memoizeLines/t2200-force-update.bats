#!/usr/bin/env bats

load fixture

@test "transform two identical lines with forced transformation" {
    for value in 1 t true
    do
	MEMOIZELINES_FORCE_UPDATE=$value run -0 memoizeLines transformer <<'EOF'
foo
bar
foo
bar
EOF
	assert_output - <<'EOF'
[foo]
[bar]
[foo]
[bar]
EOF
	assert_input $'foo\nbar\nfoo\nbar'

	setup
    done
}

@test "force new transformation for the configured line only" {
    MEMOIZELINES_FORCE_UPDATE=foo run -0 memoizeLines transformer <<'EOF'
foo
bar
foo
bar
EOF
    assert_output - <<'EOF'
[foo]
[bar]
[foo]
[bar]
EOF
    assert_input $'foo\nbar\nfoo'
}

@test "force new transformation for the configured line globs" {
    MEMOIZELINES_FORCE_UPDATE='f+(o)|new' run -0 memoizeLines transformer <<'EOF'
fo
fooo
bar
new
bar
fo
foo
fooo
new
bar
EOF
    assert_output - <<'EOF'
[fo]
[fooo]
[bar]
[new]
[bar]
[fo]
[foo]
[fooo]
[new]
[bar]
EOF
    assert_input $'fo\nfooo\nbar\nnew\nfo\nfoo\nfooo\nnew'
}
