#!/usr/bin/env bats

load temp_config

@test "passed group makes identical commands memoize to different results" {
    export testStatus=42
    export testMessage='variant without group'
    run memoizeCall testCommand

    export testStatus=88
    export testMessage='variant with group'
    run memoizeCall --memoize-group testGroup testCommand

    [ $status -eq $testStatus ]
    [ "$output" = "$testMessage" ]
}

@test "different groups make identical commands memoize to different results" {
    export testStatus=42
    export testMessage='variant in group A'
    run memoizeCall testCommand

    export testStatus=88
    export testMessage='variant in group B'
    run memoizeCall --memoize-group testGroup testCommand

    [ $status -eq $testStatus ]
    [ "$output" = "$testMessage" ]
}
