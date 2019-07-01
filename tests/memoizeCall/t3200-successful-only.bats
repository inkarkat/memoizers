#!/usr/bin/env bats

load temp_config

@test "only successful status updates record" {
    export testMessage='The first fails'
    export testStatus=1
    run memoizeCall --successful-only testCommand
    [ $status -eq 1 ]

    export testMessage='The seconds one fails, too'
    export testStatus=1
    run memoizeCall --successful-only testCommand
    [ $status -eq 1 ]
    [ "$output" = "$testMessage" ]

    export testMessage='The third one finally succeeds'
    firstSucceedingMessage="$testMessage"
    export testStatus=0
    run memoizeCall --successful-only testCommand
    [ $status -eq 0 ]
    [ "$output" = "$testMessage" ]

    export testMessage='The fourth one is not invoked'
    export testStatus=0
    run memoizeCall --successful-only testCommand
    [ $status -eq 0 ]
    [ "$output" = "$firstSucceedingMessage" ]
    assert_last "0 $firstSucceedingMessage"
}
