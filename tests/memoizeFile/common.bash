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

inputWrapper()
{
    local input="$1"; shift
    printf "%s${input:+\n}" "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}
