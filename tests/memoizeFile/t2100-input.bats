#!/usr/bin/env bats

load common

@test "non-existing file is created via standard input" {
    runWithInput 'updated via standard input' memoizeFile --file "$FILE"
    assert_updates
    [ "$output" = '' ]
}

@test "existing file is not updated via standard input, which is ignored" {
    make_new
    runWithInput 'updated via standard input' memoizeFile --file "$FILE"
    assert_not_updated
    [ "$output" = '' ]
}

@test "non-existing file is created via standard input, redirect is ignored" {
    runWithInput 'updated via standard input' memoizeFile --redirect --file "$FILE"
    assert_updates
    [ "$output" = '' ]
}
