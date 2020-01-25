#/bin/bash

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

assert_exists()
{
    [ -e "$FILE" ]
}
assert_updates()
{
    [ $(grep -c '^update' "$FILE") -eq ${1:-1} ]
}
assert_not_updated()
{
    ! grep -q '^update' "$FILE"
}
