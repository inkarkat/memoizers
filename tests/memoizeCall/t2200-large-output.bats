#!/usr/bin/env bats

load temp_config

@test "command with small output is invoked only once and returns first message and status on repeat" {
    export TOKEN='frist'
    export STATUS=0
    run memoizeCall -c 'echo $TOKEN; seq 1 1000; exit $STATUS'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    run -0 memoizeCall -c 'echo $TOKEN; seq 1 1000; exit $STATUS'
    assert_output "$firstOutput"
}

@test "command with large output is invoked only once and returns first message and status on repeat" {
    export TOKEN='frist'
    export STATUS=0
    run memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    run -0 memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'
    assert_output "$firstOutput"
}

@test "command with large output is reexecuted if the cache is gone" {
    export TOKEN='frist'
    export STATUS=0
    run memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    rm -rf -- "$XDG_CACHE_HOME/memoizeCall"
    run -11 --separate-stderr memoizeCall -c 'echo $TOKEN; seq 1 100000; exit $STATUS'
    output="$stderr" assert_output -e 'Warning: Could not read memoized output from file .*; reexecuting echo \$TOKEN; seq 1 100000; exit \$STATUS$'

    refute_output "$firstOutput"
    assert_line -n 0 "$TOKEN"
    assert_line -n 1 '1'
}

@test "command with output exceeding threshold cannot write memoized output to /etc but is recalled because still within limits" {
    [ -w /etc -o -w /etc/memoizeCall ] && skip 'Need non-writable /etc directory'
    export XDG_CACHE_HOME=/etc/memoizeCall

    export TOKEN='frist'
    export STATUS=0
    LC_ALL=C run -0 --separate-stderr memoizeCall -c 'echo $TOKEN; seq 1 9999; exit $STATUS'
    output="$stderr" assert_output - <<'EOF'
mkdir: cannot create directory '/etc/memoizeCall': Permission denied
ERROR: Could not initialize cache store at /etc/memoizeCall/memoizeCall
EOF
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    rm -rf -- "$XDG_CACHE_HOME/memoizeCall"
    run -0 --separate-stderr memoizeCall -c 'echo $TOKEN; seq 1 9999; exit $STATUS'
    assert_output "$firstOutput"
}

@test "command with large output cannot write memoized output to /etc fails, and is reexecuted" {
    [ -w /etc -o -w /etc/memoizeCall ] && skip 'Need non-writable /etc directory'
    export XDG_CACHE_HOME=/etc/memoizeCall

    export TOKEN='frist'
    export STATUS=0
    LC_ALL=C run -0 --separate-stderr memoizeCall -c 'echo $TOKEN; seq 1 98765; exit $STATUS'
    output="$stderr" assert_output -p - <<'EOF'
mkdir: cannot create directory '/etc/memoizeCall': Permission denied
ERROR: Could not initialize cache store at /etc/memoizeCall/memoizeCall
EOF
output="$stderr" assert_output -p 'executionMarker: Argument list too long'
    firstOutput="$output"

    export TOKEN='This is now different'
    export STATUS=11
    LC_ALL=C run --separate-stderr memoizeCall -c 'echo $TOKEN; seq 1 98765; exit $STATUS'

    output="$stderr" assert_output -p - <<'EOF'
mkdir: cannot create directory '/etc/memoizeCall': Permission denied
ERROR: Could not initialize cache store at /etc/memoizeCall/memoizeCall
EOF
output="$stderr" assert_output -p 'executionMarker: Argument list too long'

    refute_output "$firstOutput"
    assert_line -n 0 "$TOKEN"
    assert_line -n 1 '1'
}
