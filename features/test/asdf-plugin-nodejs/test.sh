#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking the nodejs plugin is installed..."
assert_command "asdf plugin list 2>&1 | grep nodejs"

echo "Checking current lts is installed..."
nodejs_lts_version=$(asdf cmd nodejs resolve lts)
assert_command "asdf list | grep $nodejs_lts_version"
