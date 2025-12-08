#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export RECORD="${BATS_TMPDIR}/record"

clean_recorder()
{
    rm -f -- "$RECORD"
}
fixtureSetup()
{
    clean_recorder
}
setup()
{
    fixtureSetup
}

dump_input()
{
    sed -e 's/^/#/' "$RECORD" >&3
}
assert_input()
{
    if ! [ "$(cat -- "$RECORD")" = "${1?}" ]; then
	dump_input
	return 1
    fi
}

recorder()
{
    tee --append -- "$RECORD"
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

failOnBarTransformer()
{
    recorder | sed -e "/bar/q 99"
}
export -f failOnBarTransformer
argTransformer()
{
    printf '%s\n' "$*" | recorder | sed -e 's/.*/[&]/'
}
export -f argTransformer

export uppercaseCommand=(tr a-z A-Z)
export firstToBeginCommand=(sed 's/first/begin/')
