#!/bin/bash

export XDG_DATA_HOME="$BATS_TMPDIR"

setup() {
    clean_config
    PATH="${BATS_TEST_DIRNAME}/commands:$PATH"
    export BATS_TMPDIR
}

clean_config()
{
    rm -rf "${XDG_DATA_HOME}/memoizeCall" "${XDG_DATA_HOME}/memoizeCall.d"
}

initialize_config()
{
    [ "$1" = from ] || exit 2
    cp -f "${BATS_TEST_DIRNAME}/config/${2:?}" "${XDG_DATA_HOME}/memoizeCall"
}

assert_last()
{
    IFS=$'\n' read -r last < "${BATS_TMPDIR}/lastMessage"
    [ "$last" = "$1" ]
}

dump_config()
{
    prefix '#' "${XDG_DATA_HOME}/memoizeCall" >&3
}
