ARG VARIANT="trixie"

FROM docker.io/library/buildpack-deps:${VARIANT}-curl

LABEL org.opencontainers.image.source=https://github.com/thoughtbot/devcontainers
LABEL org.opencontainers.image.description="Debian Dev Container Image"
LABEL org.opencontainers.image.licenses=MIT

ENV LANG=C.UTF-8

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*
