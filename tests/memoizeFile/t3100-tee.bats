#!/usr/bin/env bats

load fixture

@test "non-existing file is created via standard input and printed" {
    run -0 memoizeFile --tee --file "$FILE" <<<'updated via standard input'
    assert_updates
    assert_output 'updated via standard input'
}

@test "existing file is updated via standard input and printed" {
    echo 'old contents' > "$FILE"
    make_old
    run -0 memoizeFile --tee --for 1h --file "$FILE" <<<'updated via standard input'
    assert_updates
    assert_output 'updated via standard input'
}

@test "existing file is not updated via standard input but still printed" {
    make_new
    run -0 memoizeFile --tee --file "$FILE" <<<'updated via standard input'
    assert_not_updated
    assert_output 'updated via standard input'
}

@test "non-existing file is created via redirection of commandline and printed" {
    run -0 memoizeFile --tee --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_file_exists "$FILE"
    assert_updates
    assert_output 'updated via command-line'
}

@test "existing file is not updated via redirection of commandline and old contents printed" {
    echo 'old contents' > "$FILE"
    run -0 memoizeFile --tee --redirect --file "$FILE" --command 'echo updated via command-line'
    assert_not_updated
    assert_output 'old contents'
}

@test "existing file is not updated via redirection if the command fails and old contents printed" {
    echo 'old contents' > "$FILE"
    make_old
    run -1 memoizeFile --tee --redirect --for 1h --file "$FILE" --command 'echo updated via command-line; false'
    assert_not_updated
    assert_output 'old contents'
}
