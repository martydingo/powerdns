#!/bin/bash

/dsc-entrypoint.sh && /usr/local/sbin/pdns_server --guardian=yes --daemon=no --write-pid=no --config-dir=/etc/powerdns