#!/bin/sh

set -eu

export DEBIAN_FRONTEND="noninteractive"

system_architecture() {
	architecture=$(dpkg --print-architecture)

	case "$architecture" in
		amd64)
			echo "linux64"
			;;
		*)
			echo "Unknown architecture: $architecture"
			exit 1
			;;
	esac
}

fetch_last_known_good_versions() {
	channel=$1

	url="https://googlechromelabs.github.io/chrome-for-testing"
	url="$url/last-known-good-versions-with-downloads.json"

	curl --silent "$url" | \
		jq ".channels | with_entries(.key |= ascii_downcase) | .$channel"
}

extract_download_url() {
	data=$1
	tool=$2
	platform=$3

	echo "$data" | \
		jq -r ".downloads.$tool | .[] | select(.platform == \"$platform\") | .url"
}

install_google_chrome() {
	url=$1
	arch=$2
	archive_name="chrome-$arch"

	curl -Lo "$archive_name.zip" "$url"
	unzip "$archive_name".zip
	mv "$archive_name" /opt/google-chrome

	while read -r pkg; do
		apt-get satisfy -y --no-install-recommends "$pkg";
	done < /opt/google-chrome/deb.deps;

	rm "$archive_name.zip"
}

install_chromedriver() {
	url=$1
	arch=$2
	archive_name="chromedriver-$arch"

	curl -Lo "$archive_name.zip" "$url"
	unzip "$archive_name".zip
	mv "$archive_name/chromedriver" /usr/local/bin/chromedriver

	rm "$archive_name.zip"
}

apt-get update -qy

if ! command -v unzip > /dev/null; then
	apt-get -qy install unzip
fi

arch=$(system_architecture)
data=$(fetch_last_known_good_versions "stable")
google_chrome_url=$(extract_download_url "$data" chrome "$arch")
chromedriver_url=$(extract_download_url "$data" chromedriver "$arch")

install_google_chrome "$google_chrome_url" "$arch"
install_chromedriver "$chromedriver_url" "$arch"

ln -s /opt/google-chrome/chrome /usr/local/bin/google-chrome
ln -s /opt/google-chrome/chrome /usr/local/bin/google-chrome-stable
