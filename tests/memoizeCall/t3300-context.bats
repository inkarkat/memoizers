#!/usr/bin/env bats

load temp_config

@test "passed context makes identical commands memoize to different results" {
    export testStatus=42
    export testMessage='variant without group'
    run memoizeCall testCommand

    export testStatus=88
    export testMessage='variant with context'
    run memoizeCall --context testContext testCommand
    assert_failure $testStatus
    assert_output "$testMessage"
}

@test "different contexts make identical commands memoize to different results" {
    export testStatus=42
    export testMessage='variant in context A'
    run memoizeCall --context A testCommand

    export testStatus=88
    export testMessage='variant in context B'
    run memoizeCall --context B testCommand
    assert_failure $testStatus
    assert_output "$testMessage"
}

@test "additional context makes identical commands memoize to different results" {
    export testStatus=42
    export testMessage='variant in context A'
    run memoizeCall --context A testCommand

    export testStatus=88
    export testMessage='variant in context A and B'
    run memoizeCall --context A --context B testCommand
    assert_failure $testStatus
    assert_output "$testMessage"
}
