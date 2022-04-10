#!/usr/bin/env bats

load fixture

@test "special exit status on bar drops that line once" {
    runWithInput $'first\nfoo\nbar\nfoo\nfoobar\nlast' memoizeLines --drop-on 99 --command failOnBarTransformer
    [ $status -eq 0 ]
    [ "$output" = "first
foo
foo
last" ]
    assert_input $'first\nfoo\nbar\nfoobar\nlast'
}

@test "different exit status on stuff still aborts" {
    runWithInput $'first\nfoo\nbar\nfoo\nstuff\nlast' memoizeLines --drop-on 99 --command failOnBarTransformer --command 'sed "/stuff/q 42"'
    [ $status -eq 42 ]
    [ "$output" = "first
foo
foo" ]
    assert_input $'first\nfoo\nbar\nstuff'
}

@test "special exit status on bar is cached, too" {
    runWithInput $'first\nfoo\nbar\nfoo\nbar\nfoobar\nfoobar\nlast' memoizeLines --drop-on 99 --command failOnBarTransformer
    [ $status -eq 0 ]
    [ "$output" = "first
foo
foo
last" ]
    assert_input $'first\nfoo\nbar\nfoobar\nlast'
}
