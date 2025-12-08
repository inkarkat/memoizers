#!/usr/bin/env bats

load fixture

@test "when file is not updated by the command, exits with 4" {
    make_old
    run -0 -4 memoizeFile --for 1h --file "$FILE" -- true
    assert_output ''
}

@test "when file is not updated by the command, verbose output says reason" {
    make_old
    run -4 memoizeFile --verbose --for 1h --file "$FILE" -- true
    assert_line -n 0 -e '/file needs an update; last update was 86400 second\(s\) ago\.$'
    assert_line -n 1 -e '^ERROR: .*/file was not updated as a side effect of executing COMMAND\.$'
}
