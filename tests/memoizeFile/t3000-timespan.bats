#!/usr/bin/env bats

load fixture

@test "non-existing file is created via simple command" {
    run -0 memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    assert_output ''
}

@test "old file is updated via simple command" {
    make_old
    run -0 memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    assert_output ''
}

@test "old file is updated via commandline that uses the placeholder" {
    make_old
    run -0 memoizeFile --for 1h --file "$FILE" --command 'echo updated via command-line > {}'
    assert_file_exists "$FILE"
    assert_updates
    assert_output ''
}

@test "new file is not updated via simple command" {
    make_new
    run -0 memoizeFile --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_not_updated
    assert_output ''
}

@test "new file is not updated via commandline that uses the placeholder" {
    make_new
    run -0 memoizeFile --for 1h --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    assert_output ''
}
