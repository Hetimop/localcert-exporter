#!/bin/sh
set -e

useradd --shell /bin/false pwn 

if [ -n "$METRICS_PORT" ]; then
  sed -i "s/port = .*$/port = ${METRICS_PORT}/" /etc/xinetd.d/pwn
fi

exec /usr/sbin/xinetd -dontfork
