#!/usr/bin/env bats

load fixture

@test "very verbose special exit status on bar drops that line once" {
    run -0 memoizeLines --verbose --verbose --drop-on 99 --command failOnBarTransformer <<'EOF'
foo
bar
EOF
    assert_output - <<'EOF'
memoizeLines: Cache miss for "foo": foo
foo
memoizeLines: Cache miss for "bar" (dropped input line)
memoizeLines: 2 lines, 0 cache hits (0%).
EOF
    assert_input $'foo\nbar'
}
