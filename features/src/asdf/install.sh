#!/bin/sh

set -eu

gh_api() {
	path=$1
	authentication=

	if [ -n "${GH_TOKEN+set}" ]; then
		authentication="-H \"Authorization: Bearer $GH_TOKEN\""
	fi

	curl --silent "$authentication -H Accept: application/vnd.github+json" \
		-H "X-GitHub-Api-Version: 2026-03-10" \
		"https://api.github.com/$path"
}

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

if [ "$VERSION" = "latest" ]; then
	VERSION=$(gh_api repos/asdf-vm/asdf/releases/latest | jq -r ".name")
fi

kernel_name=$(uname -s | tr '[:upper:]' '[:lower:]')
architecture=$(dpkg --print-architecture)

if ! command -v asdf > /dev/null; then
	filename="asdf-$VERSION-$kernel_name-$architecture.tar.gz"

	curl -Lo "$filename" "https://github.com/asdf-vm/asdf/releases/download/$VERSION/$filename"
	tar -xzvf "$filename" asdf
	sudo mv asdf /usr/local/bin/asdf

	rm "$filename"
fi

mkdir -p /opt/asdf
chown "$USERNAME" /opt/asdf
