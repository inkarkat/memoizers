#!/usr/bin/env bats

load fixture

@test "old file is updated twice via commandline" {
    make_old
    run -0 memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_file_exists "$FILE"
    assert_updates 1
    assert_output -e '/file needs an update; last update was 1 day ago\.$'

    sleep 0.8
    run -0 memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_updates 1
    assert_output -e '/file does not need an update yet; last update was 1 second ago\.$'

    sleep 1.2
    run -0 memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_updates 2
    assert_output -e '/file needs an update; last update was 2 seconds ago\.$'
}
