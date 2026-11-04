#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking we've got Chrome..."
assert_command "chrome --version"

echo "Checking we've got chromedriver..."
assert_command "chromedriver --version"

echo "Checking we've got Ruby via asdf..."
assert_command "asdf list | grep ruby"

echo "Checking we've got Node via asdf..."
assert_command "asdf list | grep nodejs"
