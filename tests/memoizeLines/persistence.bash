#!/bin/bash

load fixture

export XDG_CACHE_HOME="$BATS_TMPDIR"

persistenceSetup()
{
    clean_cache
}
setup()
{
    fixtureSetup
    persistenceSetup
}

clean_cache()
{
    rm -rf "${XDG_CACHE_HOME}/memoizeLines"
}
