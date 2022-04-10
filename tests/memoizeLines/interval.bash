#!/bin/bash

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
