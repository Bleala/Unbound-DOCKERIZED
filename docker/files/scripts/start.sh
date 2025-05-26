#!/bin/sh

# Create trust anchor file on start
/opt/unbound/sbin/unbound-anchor -a "/etc/unbound/root.key"

# Check if an unbound configuration file is provided
if [ ! -f "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}" ]
then
    # Copy the default configuration file if no other is provided
    cp /files/examples/unbound.conf "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"

    # Set permissions for the configuration file
    chmod 600 "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
    chown "${UNBOUND_USER:-unbound}":"${UNBOUND_USER:-unbound}" "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
fi

# Start unbound
exec /opt/unbound/sbin/unbound -d -c "${UNBOUND_CONFIG:-/etc/unbound/unbound.conf}"
