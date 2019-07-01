#!/usr/bin/env bats

load temp_config

@test "simple command" {
    export testMessage='Just a simple command'
    run memoizeCall testCommand
    [ $status -eq 0 ]
    [ "$output" = "$testMessage" ]
}

@test "simple command after --" {
    export testMessage='Just a simple command after --'
    run memoizeCall -- testCommand
    [ $status -eq 0 ]
    [ "$output" = "$testMessage" ]
}

@test "commandline" {
    export testMessage='Just a commandline'
    run memoizeCall --command testCommand
    [ $status -eq 0 ]
    [ "$output" = "$testMessage" ]
}

@test "command from stdin" {
    export testMessage='Just a command from stdin'
    output="$(echo testCommand | memoizeCall)"
    [ "$output" = "$testMessage" ]
}

@test "simple command returning failure" {
    export testMessage='Just a failing command'
    export testStatus=42
    run memoizeCall testCommand
    [ $status -eq 42 ]
    [ "$output" = "$testMessage" ]
}

@test "simple command returning multi-line text" {
    export testMessage=$'Some\n\tmore\t    lines.'
    run memoizeCall testCommand
    [ $status -eq 0 ]
    [ "$output" = "$testMessage" ]
}
