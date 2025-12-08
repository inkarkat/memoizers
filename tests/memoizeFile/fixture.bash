#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert
bats_load_library bats-file

FILE="${BATS_TMPDIR}/file"

setup()
{
    rm -f "$FILE"
}

make_new()
{
    touch -- "$FILE"
}
make_old()
{
    touch -m --date yesterday -- "$FILE"
}

dump_updates()
{
    printf >&3 '# Got %d update(s)\n' "$(grep -c '^update' "$FILE")"
}
assert_updates()
{
    [ $(grep -c '^update' "$FILE") -eq ${1:-1} ]
}
assert_not_updated()
{
    ! grep -q '^update' "$FILE"
}
