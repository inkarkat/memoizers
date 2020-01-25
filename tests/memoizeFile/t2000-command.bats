#!/usr/bin/env bats

load common

@test "non-existing file is created via simple command" {
    run memoizeFile --file "$FILE" -- touch "$FILE"
    assert_exists
    [ "$output" = '' ]
}

@test "non-existing file is created via simple command that uses the placeholder" {
    run memoizeFile --file "$FILE" -- touch '{}'
    assert_exists
    [ "$output" = '' ]
}

@test "non-existing file is created via commandline that uses the placeholder" {
    run memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_exists
    assert_updates
    [ "$output" = '' ]
}

@test "existing file is not updated via commandline that uses the placeholder" {
    make_new
    run memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    [ "$output" = '' ]
}
