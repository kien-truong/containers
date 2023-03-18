FROM ghcr.io/kien-truong/ubuntu:jammy as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM

USER root

RUN set -eux && \
    apt-get -qq update && \
    apt-get -qq install -y \
        git \
        build-essential \
        cmake \
        ninja-build \
        python3 \
        libtool \
        pkg-config \
        intltool \
        libcurl4-openssl-dev \
        libevent-dev \
        libminiupnpc-dev \
        libssl-dev

WORKDIR /tmp/transmission

# Compile transmission
ARG VERSION
RUN git clone --depth 1 -b ${VERSION} https://github.com/transmission/transmission.git . && \
    git submodule update --init --recursive && \
    cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_GTK=OFF \
        -DENABLE_QT=OFF \
        -DENABLE_UTILS=OFF \
        -DENABLE_CLI=OFF \
        -DENABLE_TESTS=OFF \
        -DINSTALL_DOC=OFF && \
    cmake --build build && \
    cmake --install build

FROM ghcr.io/kien-truong/ubuntu:jammy

ARG TARGETPLATFORM

CMD ["/app/entrypoint.sh"]

ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    WEBUI_PORT=9091 \
    TRANSMISSION_WEB_HOME=/app/public_html

USER root

RUN set -eux && \
    apt-get -qq update && \
    apt-get install -y \
        libcurl4 \
        libevent-2.1-7 \
        libminiupnpc17 \
        libnatpmp1 \
        libssl3 \
        zlib1g && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ && \
    mkdir -p /downloads /watch && \
    chown -R app-user:app-user /downloads /watch && \
    chmod -R u=rwX,go=rX /downloads && \
    printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

EXPOSE ${WEBUI_PORT} 51413

VOLUME ["/downloads", "/watch"]

COPY --from=builder /usr/local/bin/transmission-daemon /app/transmission-daemon
COPY --from=builder /usr/local/share/transmission/public_html /app/public_html
COPY ./apps/transmission/settings.json.tmpl /app/settings.json.tmpl
COPY ./apps/transmission/entrypoint.sh /app/entrypoint.sh
RUN chmod -R +r /app && \
    chmod +x /app/entrypoint.sh

USER app-user

ARG VERSION
LABEL \
    org.opencontainers.image.title="Transmission Bittorrent Client" \
    org.opencontainers.image.source="https://github.com/transmission/transmission" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.authors="Kien Truong <duckientruong@gmail.com>" \
    org.opencontainers.image.base.name="ghcr.io/kien-truong/ubuntu" \
    org.opencontainers.image.base.version="jammy"
