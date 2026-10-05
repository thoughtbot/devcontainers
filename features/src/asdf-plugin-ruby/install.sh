#!/bin/sh

set -eu

VERSIONS="${VERSIONS:-}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

case "$USERNAME" in
	auto*)
		USERNAME=
		uid_1000="$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)"
		possible_users="vscode node codespace $uid_1000"

		while read -r user; do
			if id -u "$user" > /dev/null 2>&1; then
				USERNAME="$user"
				break
			fi
		done <<-EOT
			$(echo "$possible_users" | tr ' ' '\n')
		EOT

		if [ "$USERNAME" = "" ]; then
			USERNAME=root
		fi
		;;
	"none")
		USERNAME="root"
		;;
esac

run_as() {
	runuser -u "$USERNAME" -- "$@"
}

apt-get -q update
apt-get -qy install build-essential autoconf libssl-dev libyaml-dev \
	zlib1g-dev libffi-dev libgmp-dev rustc

if ! run_as asdf plugin list 2>&1 | grep ruby > /dev/null; then
	run_as asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
fi

echo "$VERSIONS" | tr ',' '\n' | while read -r version; do
	if [ "$version" = "" ]; then
		continue
	fi

	run_as asdf install ruby "$version"
done
