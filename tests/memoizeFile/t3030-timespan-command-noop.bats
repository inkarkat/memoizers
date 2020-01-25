#!/usr/bin/env bats

load common

@test "when file is not updated by the command, exits with 4" {
    make_old
    run memoizeFile --for 1h --file "$FILE" -- true
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "when file is not updated by the command, verbose output says reason" {
    make_old
    run memoizeFile --verbose --for 1h --file "$FILE" -- true
    [[ "${lines[0]}" =~ /file\ needs\ an\ update\;\ last\ update\ was\ 86400\ second\(s\)\ ago\.$ ]]
    [[ "${lines[1]}" =~ ^ERROR:\ .*/file\ was\ not\ updated\ as\ a\ side\ effect\ of\ executing\ COMMAND\.$ ]]
}
