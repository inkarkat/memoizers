#!/usr/bin/env bats

load fixture
load delay

@test "outdated cache entries get removed before evicting valid ones" {
    runWithDelayInput -0 foo 2 $'bar\nfoo' 1 $'third\nbar\nfoo' -- memoizeLines --for 2s --size 2 transformer
    assert_output - <<'EOF'
[foo]
[bar]
[foo]
[third]
[bar]
[foo]
EOF
    assert_input $'foo\nbar\nthird\nfoo'
}
