#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 memoizeFile
    assert_line -n 0 'ERROR: No FILE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "unknown option prints message and usage instructions" {
    run -2 memoizeFile --for 1h --file /dev/null --what-is-this --command uname
    assert_line -n 0 'ERROR: Unknown option "--what-is-this"!'
    assert_line -n 2 -e '^Usage:'
}

@test "complains about illegal timespan" {
    run -2 memoizeFile --for whatever --file /dev/null
    assert_line -n 0 'ERROR: Illegal TIMESPAN or TIMESLOT: whatever'
    assert_line -n 1 -e '^Usage:'
}
