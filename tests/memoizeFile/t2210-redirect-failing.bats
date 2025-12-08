#!/usr/bin/env bats

load fixture

@test "non-existing file is not updated via redirection if the command fails" {
    run -1 memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line; false'
    assert_not_updated
    assert_output ''
}

@test "existing file is not updated via redirection if one commandline update exits" {
    make_old
    run -33 memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command 'exit 33' echo updated via simple command
    assert_not_updated
    assert_output ''
}

@test "existing file is updated via redirection if one intermediate commandline update fails" {
    make_old
    run -0 memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command '(exit 33)' --command 'echo updated second via command-line' echo updated via simple command
    assert_updates 3
    assert_success
    assert_output ''
}

@test "existing file is not updated via redirection if the last commandline update fails" {
    make_old
    run -33 memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command 'echo updated second via command-line' --command '(exit 33)'
    assert_not_updated
    assert_output ''
}
