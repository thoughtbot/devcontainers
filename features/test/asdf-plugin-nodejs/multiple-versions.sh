#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking Node v22.23.3 is installed..."
assert_command "asdf list nodejs 2>&1 | grep 22.23.3"

echo "Checking Node v24.21.0 is installed..."
assert_command "asdf list nodejs 2>&1 | grep 24.21.0"
