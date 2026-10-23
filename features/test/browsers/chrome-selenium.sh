#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

sudo apt-get update
sudo apt-get install -qy --no-install-recommends python3-selenium

echo "Checking that Chrome can be used via Selenium..."
assert_command "python3 test_selenium.py"
