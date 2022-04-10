#!/bin/bash

delayInputWrapper()
{
    typeset -a parts
    while [ $# -ne 0 -a "$1" != '--' ]
    do
	parts+=("$1"); shift
    done; shift

    local part; for part in "${parts[@]}"
    do
	if [[ "$part" =~ ^[[:digit:].]+[smhd]?$ ]]; then
	    sleep "$part"
	else
	    printf '%s\n' "$part"
	fi
    done | "$@"
}
runWithDelayInput()
{
    run delayInputWrapper "$@"
}
