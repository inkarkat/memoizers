#!/bin/bash

export RECORD="${BATS_TMPDIR}/record"

setup()
{
    rm -f -- "$RECORD"
}

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

filterTransformer()
{
    tee -a -- "$RECORD" | sed -e '/^f/d' -e 's/.*/[&]/'
}
export -f filterTransformer

export uppercaseCommand=(tr a-z A-Z)
export firstToBeginCommand=(sed 's/first/begin/')
