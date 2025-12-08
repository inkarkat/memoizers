#!/usr/bin/env bats

load fixture

@test "message about non-existing file" {
    run -0 memoizeFile --verbose --file "$FILE" -- touch "$FILE"
    assert_file_exists "$FILE"
    assert_output -e /file\ does\ not\ exist\ yet\.$
}

@test "message about existing file is not updated" {
    make_new
    run -0 memoizeFile --verbose --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    assert_output -e /file\ already\ exists\.$
}
