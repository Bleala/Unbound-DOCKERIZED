# Global variables
ARG ALPINE_VERSION="3.23.4" \
    UNBOUND_USER="unbound" \
    UNBOUND_VERSION="1.25.1" \
    NGTCP2_VERSION="1.24.0"

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building ngtcp2
FROM alpine:${ALPINE_VERSION} AS ngtcp2-build

ARG ALPINE_VERSION \
    NGTCP2_VERSION \
    NGTCP2_DOWNLOAD="https://github.com/ngtcp2/ngtcp2/releases/download/v${NGTCP2_VERSION}/ngtcp2-${NGTCP2_VERSION}.tar.gz" \
    NGTCP2_DOWNLOAD_CHECKSUM="https://github.com/ngtcp2/ngtcp2/releases/download/v${NGTCP2_VERSION}/checksums.txt"

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set workdir
WORKDIR /tmp/ngtcp2-build

# Install build dependencies and download ngtcp2 source code
RUN set -x && \
    apk add --no-cache --virtual .build-deps \
      # For strip command to reduce binary size
      binutils \
      build-base \
      curl \
      openssl-dev \
      pkgconf && \
    # Download ngtcp2
    curl -sSLO "${NGTCP2_DOWNLOAD}" && \
    # Download SHA256 checksum
    curl -sSLO "${NGTCP2_DOWNLOAD_CHECKSUM}" && \
    # Compare the checksum
    grep "ngtcp2-${NGTCP2_VERSION}.tar.gz" checksums.txt | sha256sum -c - && \
    # Extract the tarball
    tar -xzf "ngtcp2-${NGTCP2_VERSION}.tar.gz"

# Set workdir to the extracted ngtcp2 directory
WORKDIR /tmp/ngtcp2-build/ngtcp2-${NGTCP2_VERSION}

# Build ngtcp2
RUN set -x && \
    ./configure \
      LDFLAGS="-Wl,-rpath,/usr/local/lib" && \
    # Set max number of cores --> one less than total
    CORES=$(nproc); CORES=$((CORES > 1 ? CORES - 1 : 1)) && \
    # Compile and install ngtcp2
    make -j "${CORES}" && \
    make install

# Strip libraries
RUN find /usr/local/lib -type f -name "*.so*" -exec strip --strip-unneeded {} +

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building Unbound
FROM alpine:${ALPINE_VERSION} AS unbound-build

# Set arguments for Unbound version and build date
ARG ALPINE_VERSION \
    UNBOUND_USER \
    UNBOUND_VERSION \
    UNBOUND_DOWNLOAD="https://nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz"

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set workdir
WORKDIR /tmp/unbound-build

# Copy files before install, otherwise cache would break
# Copy the ngtcp2 library files
COPY --from=ngtcp2-build /usr/local/lib /usr/local/lib

# Copy the ngtcp2 header files
COPY --from=ngtcp2-build /usr/local/include /usr/local/include

# Install build dependencies and download unbound source code
RUN set -x && \
    apk add --no-cache --virtual .build-deps \
      # For strip command to reduce binary size
      binutils \
      build-base \
      curl \
      expat-dev \
      hiredis-dev \
      libevent-dev \
      libsodium-dev \
      nghttp2-dev \
      # Manually build ngtcp2
      # ngtcp2-dev \
      openssl-dev \
      pkgconf \
      protobuf-c-dev && \
    # Download Unbound
    curl -sSLO "${UNBOUND_DOWNLOAD}" && \
    # Download SHA256 checksum
    curl -sSLO "${UNBOUND_DOWNLOAD}.sha256" && \
    # Compare the checksum
    echo "$(cat "unbound-${UNBOUND_VERSION}.tar.gz.sha256")" "unbound-${UNBOUND_VERSION}.tar.gz" | sha256sum -c - && \
    # Extract the tarball
    tar -xzf "unbound-${UNBOUND_VERSION}.tar.gz"

# Set workdir to the extracted Unbound directory
WORKDIR /tmp/unbound-build/unbound-${UNBOUND_VERSION}

# Build Unbound
RUN set -x && \
    # Fix Quic for Openssl 3.5.x --> error: implicit declaration of function 'SSL_set_quic_early_data_enabled'; did you mean 'SSL_set_quic_tls_early_data_enabled'?
    # GitHub Issue: https://github.com/NLnetLabs/unbound/issues/1306
    sed -i 's/SSL_set_quic_early_data_enabled/SSL_set_quic_tls_early_data_enabled/g' services/listen_dnsport.c && \
    # Configure Unbound
    ./configure \
      --prefix=/opt/unbound \
      --with-conf-file=/etc/unbound/unbound.conf \
      --with-run-dir=/var/unbound \
      --with-chroot-dir=/var/unbound \
      --with-pidfile=/var/unbound/unbound.pid \
      --with-rootkey-file=/var/unbound/root.key \
      --with-username="${UNBOUND_USER}" \
      --with-pthreads \
      --with-ssl \
      --with-libevent \
      --with-libhiredis \
      --with-libnghttp2 \
      --with-libngtcp2 \
      --with-libsodium=/usr \
      --enable-cachedb \
      --enable-dnscrypt \
      --enable-dnstap \
      --enable-event-api \
      --enable-pie \
      --enable-relro-now \
      --enable-subnet \
      --enable-tfo-server \
      --enable-tfo-client \
      --disable-static && \
    # Set max number of cores --> one less than total
    CORES=$(nproc); CORES=$((CORES > 1 ? CORES - 1 : 1)) && \
    # Compile and install Unbound
    make -j "${CORES}" && \
    make install

# Cleanup unused files and reduce binary size
RUN rm -rf /opt/unbound/include \
           /opt/unbound/share \
           /opt/unbound/lib/pkgconfig \
           /opt/unbound/lib/*.la && \
    # Strip binaries
    # Ignore errors --> unbound-control-setup is a script
    strip /opt/unbound/sbin/* > /dev/null 2>&1 || true && \
    # Strip libraries
    find /opt/unbound/lib -type f -name "*.so*" -exec strip --strip-unneeded {} +

# Set workdir to var
WORKDIR /var/unbound

# https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound-anchor.html
# Download the root.hints and generate the root.key
# Exit code 0 = anchor up to date, 1 = anchor updated --> both success
RUN curl -sSL https://www.internic.net/domain/named.root -o /var/unbound/root.hints && \
    ANCHOR_EXIT=0 && \
    { /opt/unbound/sbin/unbound-anchor -v -r /var/unbound/root.hints -a /var/unbound/root.key || ANCHOR_EXIT="${?}"; } && \
    if [ "${ANCHOR_EXIT:-0}" -gt 1 ]; then echo "ERROR: Command unbound-anchor failed with exit code ${ANCHOR_EXIT}."; exit 1; fi && \
    # Move unbound.conf to unbound.conf.default
    mv /etc/unbound/unbound.conf /etc/unbound/unbound.conf.default

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image
FROM alpine:${ALPINE_VERSION} AS unbound

# Build arguments
ARG ALPINE_VERSION \
    UNBOUND_USER \
    UNBOUND_USER_UID="1000" \
    UNBOUND_USER_GID="1000" \
    UNBOUND_VERSION

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set environment variables
    # Set Unbound path
ENV PATH="/opt/unbound/sbin:${PATH}" \
    # Set Timezone
    TZ="Europe/Vienna" \
    # Set Unbound configuration file
    UNBOUND_CONFIG="/etc/unbound/unbound.conf" \
    # Set Unbound Root Key File
    UNBOUND_ROOT_FILE="/var/unbound/root.key" \
    # Set Unbound user and group
    UNBOUND_USER="${UNBOUND_USER}"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD nslookup -type=NS -timeout=1 -retry=1 . 127.0.0.1 || exit 1

# Install runtime dependencies
RUN apk add --no-cache \
      expat \
      hiredis \
      libevent \
      libsodium \
      nghttp2-libs \
      # Manually build ngtcp2 --> copy from build stage
      # ngtcp2 \
      openssl \
      protobuf-c \
      tzdata

# Add Unbound user and group
RUN addgroup -g "${UNBOUND_USER_GID}" -S "${UNBOUND_USER}" && \
    adduser -u "${UNBOUND_USER_UID}" -S -D -H -G "${UNBOUND_USER}" "${UNBOUND_USER}"

# Copy Unbound from the build stage 
COPY --from=unbound-build --chown="${UNBOUND_USER_UID}:${UNBOUND_USER_GID}" /opt/unbound /opt/unbound

# Copy the Unbound configuration file
COPY --from=unbound-build --chown="${UNBOUND_USER_UID}:${UNBOUND_USER_GID}" /etc/unbound /etc/unbound

# Copy the Unbound run directory
COPY --from=unbound-build --chown="${UNBOUND_USER_UID}:${UNBOUND_USER_GID}" /var/unbound /var/unbound

# Copy the ngtcp2 library files, header files not needed at runtime
COPY --from=ngtcp2-build /usr/local/lib/libngtcp2*.so* /usr/local/lib

# Copy Files and set permissions (/files/scripts/*.sh need to be executable)
COPY --chown="${UNBOUND_USER_UID}:${UNBOUND_USER_GID}" --chmod=755 files /files

# Set workdir
# Needs to be after COPY --> otherwise would be owned by root
WORKDIR /var/unbound

# Set build date argument here, because caching would break otherwise
# It is set during the build process in the reusable workflow
ARG BUILD_DATE

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${UNBOUND_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Unbound-DOCKERIZED" \
      org.opencontainers.image.description="Unbound - a validating, recursive, and caching DNS resolver. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://unbound.docs.nlnetlabs.nl/en/latest/" \
      org.opencontainers.image.url="https://hub.docker.com/r/bleala/unbound" \
      org.opencontainers.image.source="https://github.com/Bleala/Unbound-DOCKERIZED"

# DNS Ports
EXPOSE 53/tcp
EXPOSE 53/udp
# DoH
EXPOSE 443/tcp
# DoT
EXPOSE 853/tcp
# DoQ
EXPOSE 853/udp

# Run start script
ENTRYPOINT ["/files/scripts/start.sh"]
