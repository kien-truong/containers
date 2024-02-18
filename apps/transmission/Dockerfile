ARG BASE_IMAGE=ghcr.io/kien-truong/ubuntu
ARG BASE_VERSION=jammy

FROM ${BASE_IMAGE}:${BASE_VERSION} as builder

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
        libcurl4-openssl-dev \
        libssl-dev

WORKDIR /tmp/transmission

# Compile transmission
ARG VERSION=4.0.5
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

FROM ${BASE_IMAGE}:${BASE_VERSION}

ARG TARGETPLATFORM

CMD ["/app/entrypoint.sh"]

ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    TRANSMISSION_WEBUI_PORT=9091 \
    TRANSMISSION_PEER_PORT=51413 \
    TRANSMISSION_WEB_HOME=/app/public_html

USER root

RUN set -eux && \
    apt-get -qq update && \
    apt-get install -y \
        libcurl4 \
        libssl3 && \
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

EXPOSE ${TRANSMISSION_WEBUI_PORT} ${TRANSMISSION_PEER_PORT}

VOLUME ["/downloads", "/watch", "/config"]

COPY --from=builder /usr/local/bin/transmission-daemon /app/transmission-daemon
COPY --from=builder /usr/local/share/transmission/public_html /app/public_html
COPY ./apps/transmission/settings.json.tmpl /app/settings.json.tmpl
COPY ./apps/transmission/entrypoint.sh /app/entrypoint.sh
RUN chmod -R +r /app && \
    chmod +x /app/entrypoint.sh

USER app-user

ARG BASE_IMAGE
ARG BASE_VERSION
ARG VERSION
LABEL \
    org.opencontainers.image.title="Transmission Bittorrent Client" \
    org.opencontainers.image.source="https://github.com/transmission/transmission" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.authors="Kien Truong <duckientruong@gmail.com>" \
    org.opencontainers.image.base.name="${BASE_IMAGE}" \
    org.opencontainers.image.base.version="${BASE_VERSION}"
