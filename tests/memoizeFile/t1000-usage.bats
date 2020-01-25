#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run memoizeFile
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No FILE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "unknown option prints message and usage instructions" {
    run memoizeFile --for 1h --file /dev/null --what-is-this --command uname
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--what-is-this"!' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "complains about illegal timespan" {
    run memoizeFile --for whatever --file /dev/null
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Illegal timespan: whatever' ]
}
