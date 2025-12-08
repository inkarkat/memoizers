#!/usr/bin/env bats

load fixture

@test "when file is not created by the command, exits with 4" {
    run -4 memoizeFile --file "$FILE" -- true
    assert_output ''
}

@test "when file is not created by the command, verbose output says reason" {
    run -4 memoizeFile --verbose --file "$FILE" -- true
    assert_line -n 0 -e '/file does not exist yet\.$'
    assert_line -n 1 -e '^ERROR: .*/file was not updated as a side effect of executing COMMAND\.$'
}
