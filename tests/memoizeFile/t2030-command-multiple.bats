#!/usr/bin/env bats

load common

@test "non-existing file is created via redirect of both simple command and commandline" {
    run memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line' echo updated via simple command
    assert_exists
    assert_updates 2
    [ "$output" = '' ]
}

@test "non-existing file is created via two commandlines that use the placeholder" {
    run memoizeFile --file "$FILE" --command 'echo updated via command-line > {}' --command 'echo updated via command-line again >> {}'
    assert_exists
    assert_updates 2
    [ "$output" = '' ]
}
