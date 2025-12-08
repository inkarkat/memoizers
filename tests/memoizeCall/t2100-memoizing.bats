#!/usr/bin/env bats

load temp_config

@test "simple command is invoked only once and returns first message and status on repeat" {
    export testMessage='Just a simple command'
    memoizeCall testCommand
    assert_last "0 $testMessage"

    firstTestMessage="$testMessage"
    export testMessage='This is now different'
    export testStatus=11
    run -0 memoizeCall testCommand
    assert_output "$firstTestMessage"
    assert_last "0 $firstTestMessage"
}

@test "different command is recorded independent of simple command" {
    export testMessage='Just a simple command'
    memoizeCall testCommand
    memoizeCall dummyCommand
    firstTestMessage="$testMessage"
    export testMessage='This is now different'
    export testStatus=11

    run -0 memoizeCall testCommand
    assert_output "$firstTestMessage"
    assert_last "0 $firstTestMessage"

    run -0 memoizeCall dummyCommand
    assert_output 'Just a dummy'
}

@test "different passing of command does not affect recording" {
    export testMessage='Just a simple command'
    run -0 memoizeCall <<<'testCommand'
    firstTestMessage="$testMessage"
    export testMessage='This is now different'
    export testStatus=11

    run -0 memoizeCall testCommand
    assert_output "$firstTestMessage"
    assert_last "0 $firstTestMessage"

    run -0 memoizeCall --command testCommand
    assert_output "$firstTestMessage"
    assert_last "0 $firstTestMessage"
}
