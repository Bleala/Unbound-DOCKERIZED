#!/bin/sh

# Create trust anchor file on start
/opt/unbound/sbin/unbound-anchor -a "/etc/unbound/root.key"

# Check if an unbound configuration file is valid
/opt/unbound/sbin/unbound-checkconf