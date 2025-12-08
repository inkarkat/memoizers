#!/bin/bash

load fixture

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
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" delayInputWrapper "$@"
}
