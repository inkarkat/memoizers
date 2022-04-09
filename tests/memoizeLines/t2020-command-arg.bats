#!/usr/bin/env bats

load fixture

@test "transform via plain argument to command" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines argTransformer {}
    [ $status -eq 0 ]
    [ "$output" = "[first]
[foo]
[foo bar]
[foo]
[bar]
[last]" ]
    assert_input $'first\nfoo\nfoo bar\nbar\nlast'
}

@test "transform via embellished argument to command" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines argTransformer 'arg:{}'
    [ $status -eq 0 ]
    [ "$output" = "[arg:first]
[arg:foo]
[arg:foo bar]
[arg:foo]
[arg:bar]
[arg:last]" ]
    assert_input $'arg:first\narg:foo\narg:foo bar\narg:bar\narg:last'
}

@test "transform via duplicated argument to command" {
    runWithInput $'first\nfoo\nfoo bar\nfoo\nbar\nlast' memoizeLines argTransformer 'B{}-{}E'
    [ $status -eq 0 ]
    [ "$output" = "[Bfirst-firstE]
[Bfoo-fooE]
[Bfoo bar-foo barE]
[Bfoo-fooE]
[Bbar-barE]
[Blast-lastE]" ]
    assert_input "Bfirst-firstE
Bfoo-fooE
Bfoo bar-foo barE
Bbar-barE
Blast-lastE"
}
