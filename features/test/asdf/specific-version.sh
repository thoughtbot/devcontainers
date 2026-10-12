#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking asdf version is v0.20.0..."
assert_command "asdf --version | grep v0.20.0"
