#!/usr/bin/env bats

load fixture

intervalInputWrapper()
{
    local isSubsequent delay="${1:?}"; shift
    typeset -a lines; readarray -t lines <<<"$1"; shift
    local line; for line in "${lines[@]}"
    do
	[ "$isSubsequent" ] && sleep "$delay"; isSubsequent=t
	printf '%s\n' "$line"
    done | "$@"
}
runWithIntervalInput()
{
    run intervalInputWrapper "$@"
}

@test "cache stays valid by default" {
    runWithIntervalInput .5 $'foo\nfoo' memoizeLines transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]" ]
    assert_input 'foo'
}

@test "two second delay invalidates cache" {
    runWithIntervalInput .5 $'foo\nfoo\nbar\nfoo\nfoo\n\nbar' memoizeLines --for 1s transformer
    [ $status -eq 0 ]
    [ "$output" = "[foo]
[foo]
[bar]
[foo]
[foo]
[]
[bar]" ]
    assert_input $'foo\nbar\nfoo\n\nbar'
}
