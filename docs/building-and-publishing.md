# Building, Testing and Publishing

## Images

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

## Features

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
