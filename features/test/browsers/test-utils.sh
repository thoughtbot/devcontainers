#!/bin/sh

VERBOSE="${VERBOSE:-0}"
LAST_COMMAND_OUTPUT=

# assert_command command [expected status code]
#
# Run a command and assert it's exit code is 0 or one given
assert_command() {
	cmd="$1"
	expected_return_status="${2:-0}"

	LAST_COMMAND_OUTPUT=

	# Always capture stdout and stderr, and don't let a failing command
	# cause this function to fail
	if LAST_COMMAND_OUTPUT="$(printf '%s' "$cmd" | sh -a 2>&1)"; then
		status="$?" # ok
	else
		status="$?" # also ok
	fi

	if [ ! "$VERBOSE" -eq 0 ]; then
		echo "Command: $cmd"
		echo "Command output: $LAST_COMMAND_OUTPUT"
		echo "Status code: $status"
	fi

	if [ "$status" -ne "$expected_return_status" ]; then
		echo "$cmd exited with: $status"
		exit 1
	fi
}

# assert_directory path
#
# Assert that a path exists and is a directory
assert_directory() {
	directory=$1

	assert_command "[ \$(stat -c '%F' $directory) = directory ]"
}

# assert_symlink path
#
# Assert that a path exists and is a symlink
assert_symlink() {
	path=$1

	assert_command "[ \"\$(stat -c '%F' $path)\" = \"symbolic link\" ]"
}

# assert_package package
#
# Query OS packages and assert one is installed
assert_package() {
	package=$1

	assert_command "dpkg-query --show -f='\${Package}: \${Version}' $package"
}
