#!/usr/bin/env bats

load common

@test "non-existing file is not updated via redirection if the command fails" {
    run memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line; false'
    assert_not_updated
    [ $status -eq 1 ]
    [ "$output" = '' ]
}

@test "existing file is not updated via redirection if one commandline update exits" {
    make_old
    run memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command 'exit 33' echo updated via simple command
    assert_not_updated
    [ $status -eq 33 ]
    [ "$output" = "" ]
}

@test "existing file is updated via redirection if one intermediate commandline update fails" {
    make_old
    run memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command '(exit 33)' --command 'echo updated second via command-line' echo updated via simple command
    assert_updates 3
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "existing file is not updated via redirection if the last commandline update fails" {
    make_old
    run memoizeFile --redirect --for 1h --file "$FILE" --command 'echo updated first via command-line' --command 'echo updated second via command-line' --command '(exit 33)'
    assert_not_updated
    [ $status -eq 33 ]
    [ "$output" = "" ]
}
