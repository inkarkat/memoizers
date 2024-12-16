# Memoizers

_Commands that record and recall contents, command outputs, user choices, etc._

![Build Status](https://github.com/inkarkat/memoizers/actions/workflows/build.yml/badge.svg)

### Dependencies

* Bash, GNU `sed`
* [inkarkat/executionMarker](https://github.com/inkarkat/executionMarker) for the `memoizeCall` and `memoizeDecision` commands
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
* The [shell/completions.sh](shell/completions.sh) script (meant to be sourced in `.bashrc`) defines Bash completions for the provided commands.
* The [profile/exports.sh](profile/exports.sh) sets up configuration; it only needs to be sourced once, e.g. from your `.profile`.
