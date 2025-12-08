#!/usr/bin/env bats

load fixture

@test "non-existing file is created via standard input" {
    run -0 memoizeFile --file "$FILE" <<<'updated via standard input'
    assert_updates
    assert_output ''
}

@test "existing file is not updated via standard input, which is ignored" {
    make_new
    run -0 memoizeFile --file "$FILE" <<<'updated via standard input'
    assert_not_updated
    assert_output ''
}

@test "non-existing file is created via standard input, redirect is ignored" {
    run -0 memoizeFile --redirect --file "$FILE" <<<'updated via standard input'
    assert_updates
    assert_output ''
}
