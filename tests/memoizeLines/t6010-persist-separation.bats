#!/usr/bin/env bats

load persistence

@test "two different commands use different persistence" {
    runWithInput 'foo' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input 'foo'

    clean_recorder
    runWithInput 'foo' memoizeLines --persist multiLineTransformer
    [ $status -eq 0 ]
    [ "$output" = "Start of foo:
  foo
---" ]
    assert_input 'foo'

    clean_recorder
    runWithInput 'foo' memoizeLines --persist transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input ''

    clean_recorder
    runWithInput 'foo' memoizeLines --persist multiLineTransformer
    [ $status -eq 0 ]
    [ "$output" = "Start of foo:
  foo
---" ]
    assert_input ''
}

@test "the same command can use different persistence via id" {
    runWithInput 'foo' memoizeLines --persist --id ID1 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]" ]
    assert_input 'foo'

    clean_recorder
    runWithInput 'bar' memoizeLines --persist --id ID2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[bar]" ]
    assert_input 'bar'

    clean_recorder
    runWithInput $'foo\nbar' memoizeLines --persist --id ID1 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]" ]
    assert_input 'bar'

    clean_recorder
    runWithInput $'foo\nbar' memoizeLines --persist --id ID2 transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[bar]" ]
    assert_input 'foo'
}
