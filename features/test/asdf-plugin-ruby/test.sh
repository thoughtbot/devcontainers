#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking the Ruby plugin is installed..."
assert_command "asdf plugin list 2>&1 | grep ruby"

echo "Checking expected dependency packages are installed..."
packages="build-essential autoconf libssl-dev libyaml-dev zlib1g-dev \
	libffi-dev libgmp-dev rustc"
echo "$packages" | tr ' ' '\n' | while read -r package; do
	assert_package "$package"
done
