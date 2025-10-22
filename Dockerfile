# syntax=docker/dockerfile:1

ARG ARCH=x86_64

ARG LIBTORRENT_VERSION="0.16.1"
ARG RTORRENT_VERSION="0.16.1"

ARG S6_OVERLAY_VERSION="3.2.1.0"
ARG ALPINE_VERSION="3.22"

FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS src
RUN apk --update --no-cache add tar xz
WORKDIR /src

FROM src AS src-libtorrent
ARG LIBTORRENT_VERSION
ADD https://github.com/rakshasa/libtorrent/archive/refs/tags/v${LIBTORRENT_VERSION}.tar.gz /tmp/libtorrent.tar.gz
RUN tar xf /tmp/libtorrent.tar.gz -C /src/ --strip-components=1

FROM src AS src-rtorrent
ARG RTORRENT_VERSION
ADD https://github.com/rakshasa/rtorrent/archive/refs/tags/v${RTORRENT_VERSION}.tar.gz /tmp/rtorrent.tar.gz
RUN tar xf /tmp/rtorrent.tar.gz -C /src/ --strip-components=1

FROM src AS s6-overlay
ARG S6_OVERLAY_VERSION
ARG ARCH

WORKDIR /dist

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C /dist -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz /tmp
RUN tar -C /dist -Jxpf /tmp/s6-overlay-${ARCH}.tar.xz

# add s6 optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C /dist -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C /dist -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS builder
RUN apk --update --no-cache add \
    autoconf \
    automake \
    binutils \
    build-base \
    cmake \
    curl-dev \
    libtool \
    ncurses-dev \
    tar \
    tree \
    xz \
    zlib-dev

ENV DIST_PATH="/dist"

WORKDIR /usr/local/src/libtorrent
COPY --from=src-libtorrent /src .
RUN autoreconf -vfi
RUN ./configure --enable-aligned
RUN make -j$(nproc) CXXFLAGS="-w -O3 -flto -Werror=odr -Werror=lto-type-mismatch -Werror=strict-aliasing"
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)

WORKDIR /usr/local/src/rtorrent
COPY --from=src-rtorrent /src .
RUN autoreconf -vfi
RUN ./configure --with-xmlrpc-tinyxml2 --with-ncurses
RUN make -j$(nproc) CXXFLAGS="-w -O3 -flto -Werror=odr -Werror=lto-type-mismatch -Werror=strict-aliasing"
RUN make install -j$(nproc)
RUN make DESTDIR=${DIST_PATH} install -j$(nproc)

FROM alpine:${ALPINE_VERSION} AS run

COPY --from=s6-overlay /dist /
COPY --from=builder /dist /

ENV TZ="UTC"
ENV PUID="1000"
ENV PGID="1000"
ENV S6_VERBOSITY=1

ENV XMLRPC_PORT="8000"
ENV XMLRPC_REAL_IP_FROM="0.0.0.0/32"
ENV XMLRPC_REAL_IP_HEADER="X-Forwarded-For"
ENV XMLRPC_SIZE_LIMIT="1M"

ENV RT_SEND_BUFFER_SIZE="4M"
ENV RT_RECEIVE_BUFFER_SIZE="4M"
ENV RT_PREALLOCATE_TYPE="0"
ENV RT_PEER_PORT="50000"
ENV RT_DHT_PORT="6881"
ENV RT_SESSION_SAVE_SECONDS="3600"


# increase rmem_max and wmem_max for rTorrent configuration
RUN echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf \
  && echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf \
  && sysctl -p

RUN apk --update --no-cache add \
    bash \
    binutils \
    ca-certificates \
    coreutils \
    grep \
    nginx \
    gawk \
    gettext \
    openssl \
    util-linux \
    xmlrpc-c-tools \
  && addgroup -g ${PGID} rtorrent \
  && adduser -D -H -u ${PUID} -G rtorrent -s /bin/sh rtorrent \
  && rm -rf /tmp/*

COPY rootfs /


VOLUME [ "/config", "/downloads/complete", "/downloads/incomplete" ]
ENTRYPOINT [ "/init" ]

HEALTHCHECK \
  --interval=30s \
  --timeout=20s \
  --start-period=10s \
  CMD /usr/local/bin/healthcheck
