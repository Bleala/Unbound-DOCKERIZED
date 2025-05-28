#!/bin/sh

# Check if the root key file exists
if [ ! -f "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}" ]
then
    # Create trust anchor file on start
    /opt/unbound/sbin/unbound-anchor -a "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"

    # Set permissions for the root.key file
    chmod 644 "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"
    chown "${UNBOUND_USER:-unbound}":"${UNBOUND_USER:-unbound}" "${UNBOUND_ROOT_FILE:-/var/unbound/root.key}"
fi

# Check if an unbound configuration file is provided
if [ -f "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}" ]
then
    # Check if an unbound configuration file is valid
    /opt/unbound/sbin/unbound-checkconf "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"

# What to do, if no unbound configuration file is provided
else
    # Warn if no configuration file is provided
    echo "No unbound configuration file provided!"
    echo "Exiting with error code 1."

    # Exit with error code 1
    exit 1
fi
