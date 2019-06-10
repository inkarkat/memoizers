#!/usr/bin/env bats

load temp_config

@test "passed subject makes two different commands memoize to the same" {
    export testStatus=42
    run memoizeCall --subject testSubject testCommand
    firstStatus="$status"
    firstOutput="$output"

    run memoizeCall --subject testSubject dummyCommand

    [ "$firstStatus" = "$status" ]
    [ "$firstOutput" = "$output" ]
}
