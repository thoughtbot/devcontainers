#!/bin/sh

set -eu

cwd=$(readlink -f "${0%/*}")

. "$cwd/test-utils.sh"

echo "Checking we're the 'codespace' user..."
assert_command "whoami | grep codespace"

echo "Checking sudo works..."
assert_command "sudo echo 'sudo works' | grep 'sudo works'"

echo "Checking locale..."
assert_command "locale -a | grep en_US.utf8"

echo "Checking expected packages are installed..."
packages="bzip2 ca-certificates curl gh git gnupg2 htop jq locales \
	openssh-client rsync socat strace sudo tree unzip vim-tiny wget xz-utils \
	zip zsh"
echo "$packages" | tr ' ' '\n' | while read -r package; do
	assert_package "$package"
done

echo "Checking zsh runs..."
assert_command "zsh --version"

echo "Checking zsh is default shell..."
assert_command "cat /etc/passwd | grep codespace | grep zsh"

echo "Checking git runs..."
assert_command "git --version"

echo "Checking we're running a non-packaged git..."
assert_command "which git | grep /usr/local/bin/git"
