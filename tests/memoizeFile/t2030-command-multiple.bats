#!/usr/bin/env bats

load fixture

@test "non-existing file is created via redirect of both simple command and commandline" {
    run -0 memoizeFile --redirect --file "$FILE" --command 'echo updated via command-line' echo updated via simple command
    assert_file_exists "$FILE"
    assert_updates 2
    assert_output ''
}

@test "non-existing file is created via two commandlines that use the placeholder" {
    run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}' --command 'echo updated via command-line again >> {}'
    assert_file_exists "$FILE"
    assert_updates 2
    assert_output ''
}
