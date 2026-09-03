#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking asdf runs..."
assert_command "asdf --version"

echo "Checking asdf data directory exists..."
assert_directory /opt/asdf

echo "Checking asdf data directory is owned by the container user..."
assert_owner /opt/asdf "$USER"

echo "Checking the current user can write to the asdf data directory..."
touch /opt/asdf/tmp-file
