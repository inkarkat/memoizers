#!/usr/bin/env bats

load common

@test "non-existing file is created via standard input" {
    echo updated via standard input | run memoizeFile --file "$FILE"
    assert_updates
    [ "$output" = '' ]
}

@test "existing file is not updated via standard input, which is ignored" {
    make_new
    echo updated via standard input | run memoizeFile --file "$FILE"
    assert_not_updated
    [ "$output" = '' ]
}

@test "non-existing file is created via standard input, redirect is ignored" {
    echo updated via standard input | run memoizeFile --redirect --file "$FILE"
    assert_updates
    [ "$output" = '' ]
}
