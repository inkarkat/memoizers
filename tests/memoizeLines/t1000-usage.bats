#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run memoizeLines
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No COMMAND(s) specified; need to pass -c|--command "COMMANDLINE", or SIMPLECOMMAND.' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "unknown option prints message and usage instructions" {
    run memoizeLines --for 1h --file /dev/null --what-is-this --command uname
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--what-is-this"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "complains about illegal timespan" {
    run memoizeLines --for whatever --file /dev/null
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Illegal timespan: whatever' ]
}
