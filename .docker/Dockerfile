FROM debian:bookworm-20241223-slim AS base
RUN apt-get -y update && \
  apt-get -y install --no-install-recommends \
  ca-certificates \
  git \
  ssh \
  wget \
  xz-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


FROM base AS install
ARG VERSION=
RUN wget -q https://ziglang.org/download/${VERSION}/zig-linux-x86_64-${VERSION}.tar.xz && \
  mkdir /opt/zig && \
  tar -xf zig-linux-x86_64-${VERSION}.tar.xz -C /opt/zig/ --strip-components=1


FROM base AS build
RUN useradd -m -u 1000 -s /bin/bash zig
COPY --from=install --chown=zig:zig --chmod=755 /opt/zig /usr/local/bin
USER zig
WORKDIR /usr/src
