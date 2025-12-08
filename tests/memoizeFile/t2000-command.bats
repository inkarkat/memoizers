#!/usr/bin/env bats

load fixture

@test "non-existing file is created via simple command" {
    run -0 memoizeFile --file "$FILE" -- touch "$FILE"
    assert_file_exists "$FILE"
    assert_output ''
}

@test "non-existing file is created via simple command that uses the placeholder" {
    run -0 memoizeFile --file "$FILE" -- touch '{}'
    assert_file_exists "$FILE"
    assert_output ''
}

@test "non-existing file is created via commandline that uses the placeholder" {
    run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_file_exists "$FILE"
    assert_updates
    assert_output ''
}

@test "existing file is not updated via commandline that uses the placeholder" {
    make_new
    run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    assert_output ''
}

@test "non-existing file is created via commandline that uses a custom placeholder and leaves the original placeholder intact" {
    export MEMOIZEFILE_FILE_MARKER=XX
    run -0 memoizeFile --file "$FILE" --command 'echo updated {} via command-line > XX'

    assert_file_exists "$FILE"
    assert_updates
    assert_output ''
    assert_equal "$(<"$FILE")" "updated {} via command-line"
}

@test "non-existing file is created via combined commandline and simple command that uses a custom placeholder and leaves the original placeholder intact" {
    export MEMOIZEFILE_FILE_MARKER=XX
    run -0 memoizeFile --file "$FILE" --command 'echo updated {} via command-line > XX' -- echo simple '{}' update to XX

    assert_file_exists "$FILE"
    assert_updates
    assert_output "simple {} update to $FILE"
    assert_equal "$(<"$FILE")" "updated {} via command-line"
}
