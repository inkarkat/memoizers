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

recorder()
{
    tee -a -- "$RECORD"
}
export -f recorder

transformer()
{
    recorder | sed -e 's/.*/[&]/'
}
export -f transformer

multiLineTransformer()
{
    recorder | sed -e 's/.*/Start of &:\n  &\n---/'
}
export -f multiLineTransformer

filterTransformer()
{
    recorder | sed -e '/^f/d' -e 's/.*/[&]/'
}
export -f filterTransformer

argTransformer()
{
    printf '%s\n' "$*" | recorder | sed -e 's/.*/[&]/'
}
export -f argTransformer

export uppercaseCommand=(tr a-z A-Z)
export firstToBeginCommand=(sed 's/first/begin/')
