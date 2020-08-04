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

@test "non-existing file is created via commandline that uses a custom placeholder and leaves the original placeholder intact" {
    export MEMOIZEFILE_FILE_MARKER=XX
    run memoizeFile --file "$FILE" --command 'echo updated {} via command-line > XX'

    assert_exists
    assert_updates
    [ "$output" = '' ]
    [ "$(cat "$FILE")" = "updated {} via command-line" ]
}

@test "non-existing file is created via combined commandline and simple command that uses a custom placeholder and leaves the original placeholder intact" {
    export MEMOIZEFILE_FILE_MARKER=XX
    run memoizeFile --file "$FILE" --command 'echo updated {} via command-line > XX' -- echo simple '{}' update to XX

    assert_exists
    assert_updates
    [ "$output" = "simple {} update to $FILE" ]
    [ "$(cat "$FILE")" = "updated {} via command-line" ]
}
