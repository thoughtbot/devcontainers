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

## Docs

* [Building and Publishing](docs/building-and-publishing.md): details on
  building, testing and publishing both features and images

## Examples

Some examples are live and being regularly used, some in this repo are there
to demonstrate different configuration approaches that we've seen on projects.

* This [repo has a configuration][3] based on our `debian` base image which can be
  used to work on the Dev Containers themselves,
* [`codespaces-demo`][4]: shows a simple Rails app running with a Dev Container on
  GitHub Codespaces (but not these images and features),
* [Administrate][6]: a sightly more complex Rails app, as used by contributors

## Images

* `debian` is a barebones image without any development environments
  * It's based on images provided by the `buildpack-deps` project,
  * Images are tagged by date of build, the most recent also tagged as `latest`,
* `universal` is a bigger image, inspired by [`laptop`][5], which should be
  everything you need for a web project
  * It's based on the most recent build of `debian`,
  * Images are tagged by date of build, along with a single `latest` pointed
    to the most recent

We currently only build `amd64` images, as this is enough to work with
Codespaces.

## Features

These features are intended to be used with our images, but should be
compatible with any image.

* [`asdf`](features/src/asdf): the tool version manager
  * [`asdf-plugin-nodejs`](features/src/asdf-plugin-nodejs): plugin to support
    Node.js
  * [`asdf-plugin-ruby`](features/src/asdf-plugin-ruby): plugin to support Ruby
* [`browsers`](features/src/browsers): headless browsers commonly used in tests

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
[5]: https://github.com/thoughtbot/laptop
[6]: https://github.com/thoughtbot/administrate/tree/main/.devcontainer
