#!/usr/bin/env bats

load common

@test "when file is not created by the command, exits with 4" {
    run memoizeFile --file "$FILE" -- true
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "when file is not created by the command, verbose output says reason" {
    run memoizeFile --verbose --file "$FILE" -- true
    [[ "${lines[0]}" =~ /file\ does\ not\ exist\ yet\.$ ]]
    [[ "${lines[1]}" =~ ^ERROR:\ .*/file\ was\ not\ updated\ as\ a\ side\ effect\ of\ executing\ COMMAND\.$ ]]
}
