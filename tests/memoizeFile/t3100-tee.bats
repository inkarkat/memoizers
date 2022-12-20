#!/usr/bin/env bats

load common

@test "non-existing file is created via standard input and printed" {
    runWithInput 'updated via standard input' memoizeFile --tee --file "$FILE"
    assert_updates
    [ "$output" = 'updated via standard input' ]
}

@test "existing file is updated via standard input and printed" {
    echo 'old contents' > "$FILE"
    make_old
    runWithInput 'updated via standard input' memoizeFile --tee --for 1h --file "$FILE"
    assert_updates
    [ "$output" = 'updated via standard input' ]
}

@test "existing file is not updated via standard input but still printed" {
    make_new
    runWithInput 'updated via standard input' memoizeFile --tee --file "$FILE"
    assert_not_updated
    [ "$output" = 'updated via standard input' ]
}

@test "non-existing file is created via redirection of commandline and printed" {
    run memoizeFile --tee --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_exists
    assert_updates
    [ "$output" = 'updated via command-line' ]
}

@test "existing file is not updated via redirection of commandline and old contents printed" {
    echo 'old contents' > "$FILE"
    run memoizeFile --tee --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_not_updated
    [ "$output" = 'old contents' ]
}

@test "existing file is not updated via redirection if the command fails and old contents printed" {
    echo 'old contents' > "$FILE"
    make_old
    run memoizeFile --tee --redirect --for 1h --file "$FILE" --command 'echo updated via command-line; false'
    assert_not_updated
    [ $status -eq 1 ]
    [ "$output" = 'old contents' ]
}
