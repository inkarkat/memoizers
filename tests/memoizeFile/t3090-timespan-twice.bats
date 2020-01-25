#!/usr/bin/env bats

load common

@test "old file is updated twice via commandline" {
    make_old
    run memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_exists
    assert_updates 1
    [[ "$output" =~ /file\ needs\ an\ update\;\ last\ update\ was\ 86400\ second\(s\)\ ago\.$ ]]

    sleep 1.1
    run memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_updates 1
    [[ "$output" =~ /file\ does\ not\ need\ an\ update\ yet\;\ last\ update\ was\ 1\ second\(s\)\ ago\.$ ]]

    sleep 1.1
    run memoizeFile --verbose --for 1 --file "$FILE" --command 'echo updated with $RANDOM >> {}'
    assert_updates 2
    [[ "$output" =~ /file\ needs\ an\ update\;\ last\ update\ was\ 2\ second\(s\)\ ago\.$ ]]
}
