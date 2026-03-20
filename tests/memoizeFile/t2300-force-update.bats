#!/usr/bin/env bats

load fixture

@test "existing file is forcibly updated" {
    for value in 1 t true
    do
	make_new
	MEMOIZEFILE_FORCE_UPDATE=$value run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
	assert_updates
	assert_output ''
    done
}

@test "force update for the configured file only" {
    make_new
    MEMOIZEFILE_FORCE_UPDATE="${BATS_TMPDIR}/anotherFile.txt" run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_not_updated
    assert_output ''

    make_new
    MEMOIZEFILE_FORCE_UPDATE="$FILE" run -0 memoizeFile --file "$FILE" --command 'echo updated via command-line > {}'
    assert_updates
    assert_output ''
}
