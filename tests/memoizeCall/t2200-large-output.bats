#!/usr/bin/env bats

load temp_config

@test "command with small output is invoked only once and returns first message and status on repeat" {
    export TOKEN='frist'
    export STATUS=0
    run memoizeCall -c 'echo $TOKEN; seq 1 1000; exit $STATUS'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    run memoizeCall -c 'echo $TOKEN; seq 1 1000; exit $STATUS'

    [ $status -eq 0 ]
    [ "$output" = "$firstOutput" ]
}

@test "command with large output is invoked only once and returns first message and status on repeat" {
    export TOKEN='frist'
    export STATUS=0
    run memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    run memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'

    [ $status -eq 0 ]
    [ "$output" = "$firstOutput" ]
}
