#!/usr/bin/env bats

load fixture

@test "error when both --subject and --context are passed" {
    run -2 memoizeCall --subject testSubject --context testContext testCommand
    assert_line -n 0 'ERROR: Cannot combine -s|--subject with -C|--context.'
    assert_line -n 1 -e '^Usage:'
}
