#!/usr/bin/env bats

load common

@test "non-existing file is created via redirection of simple command" {
    run memoizeFile --redirect --file "$FILE" -- uname
    assert_exists
    [ "$output" = '' ]
}

@test "non-existing file is created via redirection of commandline" {
    run memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_exists
    assert_updates
    [ "$output" = '' ]
}

@test "existing file is not updated via redirection of commandline" {
    make_new
    run memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_not_updated
    [ "$output" = '' ]
}
