#!/usr/bin/env bats

load temp_config

@test "simple command" {
    export testMessage='Just a simple command'
    run -0 memoizeCall testCommand
    assert_output "$testMessage"
}

@test "simple command after --" {
    export testMessage='Just a simple command after --'
    run -0 memoizeCall -- testCommand
    assert_output "$testMessage"
}

@test "commandline" {
    export testMessage='Just a commandline'
    run -0 memoizeCall --command testCommand
    assert_output "$testMessage"
}

@test "command from stdin" {
    export testMessage='Just a command from stdin'
    run -0 memoizeCall <<<'testCommand'
    assert_output "$testMessage"
}

@test "simple command returning failure" {
    export testMessage='Just a failing command'
    export testStatus=42
    run -42 memoizeCall testCommand
    assert_output "$testMessage"
}

@test "simple command returning multi-line text" {
    export testMessage=$'Some\n\tmore\t    lines.'
    run -0 memoizeCall testCommand
    assert_output "$testMessage"
}
