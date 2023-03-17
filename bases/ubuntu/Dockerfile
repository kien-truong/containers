ARG VERSION=jammy

FROM public.ecr.aws/lts/ubuntu:${VERSION}

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENTRYPOINT [ "/usr/bin/tini", "--" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/kien-truong/ubuntu" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Kien Truong <duckientruong@gmail.com>"

ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    UMASK="0002" \
    TZ="Etc/UTC"

USER root

# Create common app-user for our images
RUN groupadd --gid 10000 app-user && \
    adduser app-user \
        --uid 10000 \
        --gid 10000 \
        --system \
        --disabled-password \
        --no-create-home \
    && \
    mkdir -p /app /config && \
    chown -R app-user:app-user /app /config && \
    chmod -R 775 /app /config

WORKDIR /app

RUN set -eux && \
    echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends && \
    echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends && \
    echo 'APT::Get::Install-Recommends "false";' >>/etc/apt/apt.conf.d/00recommends && \
    echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends && \
    apt-get -qq update && \
    apt-get install -y \
        bash \
        ca-certificates \
        curl \
        dnsutils \
        iputils-ping \
        locales \
        tini \
        tzdata \
        vim-tiny && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/tmp/*

ENV LANG en_US.UTF-8

VOLUME ["/config"]

ARG ENVSUBST_VERSION=v1.4.2
COPY bases/ubuntu/scripts /tmp/scripts
RUN set -eux && \
    chmod +x /tmp/scripts/fetch_envsubst.sh && \
    /tmp/scripts/fetch_envsubst.sh ${ENVSUBST_VERSION} && \
    rm -rf /tmp/*
