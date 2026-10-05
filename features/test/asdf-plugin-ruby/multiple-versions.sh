#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking Ruby 3.3.6 is installed..."
assert_command "asdf list ruby 2>&1 | grep 3.3.6"

echo "Checking Ruby 4.0.7 is installed..."
assert_command "asdf list ruby 2>&1 | grep 4.0.7"
