#!/bin/sh

# Check if the root key file exists
if [ ! -f "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}" ]
then
    # Create trust anchor file on start
    /opt/unbound/sbin/unbound-anchor -a "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"

    # Set permissions for the directory
    chmod 644 "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"
    chown "${UNBOUND_USER:-unbound}":"${UNBOUND_USER:-unbound}" "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"
fi

# Check if an unbound configuration file is provided
if [ ! -f "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}" ]
then
    # Copy the default configuration file if no other is provided
    cp /files/examples/unbound.conf "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"

    # Set permissions for the configuration file
    chmod 644 "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
    chown "${UNBOUND_USER:-unbound}":"${UNBOUND_USER:-unbound}" "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
fi

# Switch to the unbound directory
cd /var/unbound || exit 1

# Start unbound
exec /opt/unbound/sbin/unbound -d -c "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
