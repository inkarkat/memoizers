#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 memoizeLines
    assert_line -n 0 'ERROR: No COMMAND(s) specified; need to pass -c|--command "COMMANDLINE", or SIMPLECOMMAND.'
    assert_line -n 1 -e '^Usage:'
}

@test "unknown option prints message and usage instructions" {
    run -2 memoizeLines --for 1h --verbose --what-is-this --command uname
    assert_line -n 0 'ERROR: Unknown option "--what-is-this"!'
    assert_line -n 1 -e '^Usage:'
}

@test "complains about illegal timespan" {
    run -2 memoizeLines --for whatever --verbose
    assert_output 'ERROR: Illegal timespan: whatever'
}
