#!/usr/bin/env bats

load common

@test "non-existing file is created via simple command" {
    run memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    [ "$output" = '' ]
}

@test "old file is updated via simple command" {
    make_old
    run memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    [ "$output" = '' ]
}

@test "old file is updated via commandline that uses the placeholder" {
    make_old
    run memoizeFile --for 1h --file "$FILE" --command 'echo updated via command-line > {}'
    assert_exists
    assert_updates
    [ "$output" = '' ]
}

@test "new file is not updated via simple command" {
    make_new
    run memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_not_updated
    [ "$output" = '' ]
}

@test "new file is not updated via commandline that uses the placeholder" {
    make_new
    run memoizeFile --for 1h --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    [ "$output" = '' ]
}
