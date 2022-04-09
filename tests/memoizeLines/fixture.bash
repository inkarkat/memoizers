#!/bin/bash

export RECORD="${BATS_TMPDIR}/record"

setup()
{
    rm -f -- "$RECORD"
}

transformer()
{
    tee -a -- "$RECORD" | sed -e 's/.*/[&]/'
}
export -f transformer

multiLineTransformer()
{
    tee -a -- "$RECORD" | sed -e 's/.*/Start of &:\n  &\n---/'
}
export -f multiLineTransformer

dump_input()
{
    prefix '#' "$RECORD" >&3
}
assert_input()
{
    [ "$(cat -- "$RECORD")" = "${1?}" ]
}

inputWrapper()
{
    local input="$1"; shift
    printf '%s\n' "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}
