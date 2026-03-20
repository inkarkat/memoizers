#!/usr/bin/env bats

load temp_config

@test "force new invocation" {
    export testMessage='Just a simple command'
    memoizeCall testCommand
    assert_last "0 $testMessage"

    for value in 1 t true
    do
	export testMessage="This is now different via $value"
	MEMOIZECALL_FORCE_UPDATE=$value run -0 memoizeCall testCommand
	assert_output "$testMessage"
	assert_last "0 $testMessage"
    done
}

@test "force new invocation for the configured subject only" {
    export testMessage='Just a simple foo command'
    memoizeCall --subject foo testCommand
    assert_last "0 $testMessage"

    export testMessage='Just a simple bar command'
    memoizeCall --subject bar testCommand
    assert_last "0 $testMessage"

    export testMessage="This is now different for foo"
    MEMOIZECALL_FORCE_UPDATE=foo run -0 memoizeCall --subject foo testCommand
    assert_output "$testMessage"
    assert_last "0 $testMessage"

    MEMOIZECALL_FORCE_UPDATE=foo run -0 memoizeCall --subject bar testCommand
    assert_output 'Just a simple bar command'
    assert_last "0 $testMessage"
}
