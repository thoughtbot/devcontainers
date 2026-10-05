# devcontainers

[Development Containers][1] that follow thoughtbot's conventions, covering
images and features for both local development (if desired) and [GitHub
Codespaces][2].

By building and publishing custom images, we can dramatically speed up the time
taken to spin up a new development environment, and keep the project-specific
overrides to a minimum.

## About Dev Containers

Dev Containers are Docker images intended for development and testing, formed
from a base image along with "features" which provide additional functionality,
such as building and installing the most recent release version of Git.

A project has it's own configuration based on this image, with overrides
specific to the project (like additional features for functionality not baked
into the image being used) and potentially a Docker Compose file for additional
services (like PostgreSQL).

## Examples

Some examples are live and being regularly used, some in this repo are there
to demonstrate different configuration approaches that we've seen on projects.

* This [repo has a configuration][3] based on our `debian` base image which can be
  used to work on the Dev Containers themselves,
* [`codespaces-demo`][4]: shows a simple Rails app running with a Dev Container on
  GitHub Codespaces (but not these images and features),

## Images

* `debian` is a barebones image without any development environments
  * It's based on images provided by the `buildpack-deps` project,
  * Images are tagged by date of build, the most recent also tagged as `latest`,

We currently only build `amd64` images, as this is enough to work with
Codespaces.

## Features

These features are intended to be used with our images, but should be
compatible with any image.

* [`asdf`](features/src/asdf): the tool version manager
  * [`asdf-plugin-nodejs`](features/src/asdf-plugin-nodejs): plugin to support
    Node.js

## Building, Testing and Publishing

### Images

Build the image:

```sh
$ devcontainer build \
    --image-name ghcr.io/thoughtbot/devcontainers/images/debian \
    --workspace-folder images/debian
```

This builds an image tagged as `latest`. This can be tested by starting the
container and running the tests:

```sh
$ devcontainer up \
    --id-label test-container=debian \
    --workspace-folder "images/debian"
$ devcontainer exec \
    --id-label test-container=debian \
    --workspace-folder images/debian \
    /bin/sh test/test.sh
```

And published:

```sh
$ docker push ghcr.io/thoughtbot/devcontainers/images/debian:latest
```

### Features

We don't need an explicit build step before testing, which can be done with:

```sh
$ devcontainer features test \
    --project-folder features \
    --features asdf \
    --base-image ghcr.io/thoughtbot/devcontainers/images/debian
```

Publishing can be done with:

```sh
$ devcontainer features publish features/src/asdf \
    --namespace thoughtbot/devcontainers/features
```

Depending on the version of the feature, this will publish tags like:
1, 1.0, 1.0.7, latest, if the feature version was "1.0.7".

## NOTES

* The `devcontainers` CLI doesn't properly support Podman (builds will fail),
* In addition, images need to exist for your current architecture;
  `buildpack-deps` isn't currently built for Apple Silicon (arm64), which is
  partly why this doesn't,
* To pull private packages from GitHub Packages, "inherit access from source
  repository" should be enabled in package settings,
* To publish packages from GitHub Actions, we also need to enable write access
  to the package from the repository

[1]: https://containers.dev/
[2]: https://github.com/features/codespaces
[3]: .devcontainer/
[4]: https://github.com/thoughtbot/codespaces-demo/tree/custom-config
