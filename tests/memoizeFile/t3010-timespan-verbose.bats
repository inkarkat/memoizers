#!/usr/bin/env bats

load fixture

@test "message about non-existing file" {
    run -0 memoizeFile --verbose --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    assert_output -e '/file does not exist yet\.$'
}

@test "mesage about old file is updated" {
    make_old
    run -0 memoizeFile --verbose --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_updates
    assert_output -e '/file needs an update; last update was 86400 second\(s\) ago\.$'
}

@test "message about new file is not updated" {
    make_new
    run -0 memoizeFile --verbose --for 1h --redirect --file "$FILE" -- echo updated via simple command
    assert_not_updated
    assert_output -e '/file does not need an update yet; last update was 0 second\(s\) ago\.$'
}
