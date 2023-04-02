FROM debian:bullseye-20230320-slim

COPY . /app/

RUN : \
    && chmod +x /app/* \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qqq --no-install-recommends \
      xinetd openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && mv /app/pwn /etc/xinetd.d/pwn \
    && useradd --shell /bin/false pwn \
    && :

WORKDIR /app

ENV METRICS_PORT 9999
EXPOSE  ${METRICS_PORT}


CMD ["/app/entrypoint.sh"]