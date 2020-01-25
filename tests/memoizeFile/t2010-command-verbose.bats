#!/usr/bin/env bats

load common

@test "message about non-existing file" {
    run memoizeFile --verbose --file "$FILE" -- touch "$FILE"
    assert_exists
    [[ "$output" =~ /file\ does\ not\ exist\ yet\.$ ]]
}

@test "message about existing file is not updated" {
    make_new
    run memoizeFile --verbose --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    [[ "$output" =~ /file\ already\ exists\.$ ]]
}
