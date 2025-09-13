FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

ARG UID
ARG GID

RUN apt update
RUN apt install -y --no-install-recommends \
  cmake \
  build-essential

RUN groupadd -g "${GID}" python \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" python

USER python

WORKDIR /src

ENTRYPOINT ["/usr/bin/bash"]