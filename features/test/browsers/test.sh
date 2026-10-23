#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking the install directory exists..."
assert_directory "/opt/google-chrome"

echo "Checking a subset of the expected dependencies are installed..."
packages="fonts-liberation libcairo2 libvulkan1"
echo "$packages" | tr ' ' '\n' | while read -r package; do
	assert_package "$package"
done

echo "Checking expected symlinks are present..."
assert_symlink "/usr/local/bin/google-chrome"
assert_symlink "/usr/local/bin/google-chrome-stable"

echo "Checking Chrome can execute..."
assert_command "google-chrome --version 2>&1 | grep \"Google Chrome for Testing\""

echo "Checking chromedriver is available..."
assert_command "chromedriver --version 2>&1 | grep \"ChromeDriver\""
