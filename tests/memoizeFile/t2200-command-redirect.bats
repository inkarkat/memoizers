#!/usr/bin/env bats

load fixture

@test "non-existing file is created via redirection of simple command" {
    run -0 memoizeFile --redirect --file "$FILE" -- uname
    assert_file_exists "$FILE"
    assert_output ''
}

@test "non-existing file is created via redirection of commandline" {
    run -0 memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_file_exists "$FILE"
    assert_updates
    assert_output ''
}

@test "existing file is not updated via redirection of commandline" {
    make_new
    run -0 memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_not_updated
    assert_output ''
}
