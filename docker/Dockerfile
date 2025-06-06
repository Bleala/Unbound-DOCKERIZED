# Global variables
ARG ALPINE_VERSION="3.21.3" \
    BUILD_DATE="2025-05-30T19:00:00Z" \
    UNBOUND_USER="unbound" \
    UNBOUND_VERSION="1.23.0"

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image for building Unbound
FROM alpine:${ALPINE_VERSION} AS unbound-build

# Set arguments for Unbound version and build date
ARG ALPINE_VERSION \
    BUILD_DATE \
    UNBOUND_USER \
    UNBOUND_VERSION \
    UNBOUND_DOWNLOAD="https://nlnetlabs.nl/downloads/unbound/unbound-${UNBOUND_VERSION}.tar.gz"

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

# Set shell to ash
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Set workdir
WORKDIR /tmp/unbound-build

# Install build dependencies, build unbound and remove dependencies
RUN set -x && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
      build-base=~0.5 \
      pkgconf=~2.3.0 \
      curl=~8.12.1 \
      openssl-dev=~3.3.3 \
      expat-dev=~2.7.0 \
      libevent-dev=~2.1.12 \
      protobuf-c-dev=~1.5.0 \
      nghttp2-dev=~1.64.0 \
      hiredis-dev=~1.2.0 \
      libsodium-dev=~1.0.20 && \
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
      --with-libsodium=/usr \
      --enable-cachedb \
      --enable-dnscrypt \
      --enable-dnstap \
      --enable-event-api \
      --enable-subnet \
      --enable-tfo-server \
      --enable-tfo-client \
      --disable-static && \
    # Compile and install Unbound
    make && \
    make install

# Set workdir to var
WORKDIR /var/unbound

# https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound-anchor.html
# Download the root.hints and generate the root.key
RUN curl -sSL https://www.internic.net/domain/named.root -o /var/unbound/root.hints && \
    /opt/unbound/sbin/unbound-anchor -v -r /var/unbound/root.hints -a /var/unbound/root.key || true && \
    # Move unbound.conf to unbound.conf.default
    mv /etc/unbound/unbound.conf /etc/unbound/unbound.conf.default
  
# Set workdir to the tmp directory
WORKDIR /tmp

# Finalize the build stage
RUN set -x && \
    rm -rf /tmp/unbound-build && \
    # Clean up build dependencies
    apk del .build-deps && \
    # Echo the build date
    echo "Build date: ${BUILD_DATE}" > /opt/unbound/build_date.txt

# -----------------------------------------------------------------------------------------------

# Set Alpine as the base image
FROM alpine:${ALPINE_VERSION}

# Build arguments
ARG ALPINE_VERSION \
    BUILD_DATE \
    UNBOUND_USER \
    UNBOUND_USER_UID="1000" \
    UNBOUND_USER_GID="1000" \
    UNBOUND_VERSION

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
  CMD nslookup -timeout=1 -retry=1 google.com 127.0.0.1 || exit 1

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

# Set workdir
WORKDIR /var/unbound

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache \
      openssl=~3.3.3 \
      libevent=~2.1.12 \
      hiredis=~1.2.0 \
      nghttp2-libs=~1.64.0 \
      libsodium=~1.0.20 \
      expat=~2.7.0 \
      protobuf-c=~1.5.0 \
      tzdata=~2025b

# Add Unbound user and group
RUN addgroup -g "${UNBOUND_USER_GID}" -S "${UNBOUND_USER}" && \
    adduser -u "${UNBOUND_USER_UID}" -S -D -H -G "${UNBOUND_USER}" "${UNBOUND_USER}"

# Copy Unbound from the build stage 
COPY --from=unbound-build /opt/unbound /opt/unbound

# Copy the Unbound configuration file
COPY --from=unbound-build /etc/unbound /etc/unbound

# Copy the Unbound run directory
COPY --from=unbound-build /var/unbound /var/unbound

# Copy Files
COPY files /files

# Set permissions for Unbound directories and scripts
RUN chown -R "${UNBOUND_USER}":"${UNBOUND_USER}" /opt/unbound && \
    chown -R "${UNBOUND_USER}":"${UNBOUND_USER}" /etc/unbound && \
    chown -R "${UNBOUND_USER}":"${UNBOUND_USER}" /var/unbound && \
    chown -R "${UNBOUND_USER}":"${UNBOUND_USER}" /files && \
    chmod +x /files/scripts/*.sh 

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
ENTRYPOINT ["sh","/files/scripts/start.sh"]
