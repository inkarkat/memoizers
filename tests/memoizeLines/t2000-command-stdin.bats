#!/usr/bin/env bats

load fixture

@test "transform first line" {
    runWithInput 'first' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]" ]
}

@test "transform two unique lines" {
    runWithInput $'first\nsecond' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[first]
[second]" ]
    assert_input $'first\nsecond'
}

@test "transform two identical lines with single transformation" {
    runWithInput $'foo\nfoo\nbar' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]" ]
    assert_input $'foo\nbar'
}

@test "transform empty lines with single transformation" {
    runWithInput $'foo\n\n\nbar\n\nbaz' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[]
[]
[bar]
[]
[baz]" ]
    assert_input $'foo\n\nbar\nbaz'
}

@test "transform to multiple lines" {
    runWithInput $'foo\nfoo\nbar' memoizeLines multiLineTransformer
    [ $status -eq 0 ]
    [ "$output" = "Start of foo:
  foo
---
Start of foo:
  foo
---
Start of bar:
  bar
---" ]
    assert_input $'foo\nbar'
}

@test "transform to empty lines" {
    runWithInput $'foo\nfoo\nbar' memoizeLines filterTransformer
    [ $status -eq 0 ]
    [ "$output" = "

[bar]" ]
    assert_input $'foo\nbar'
}
