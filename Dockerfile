FROM debian:bullseye-20230320-slim

# Add image information
LABEL \
    category="shell-exporter" \
    maintainers="Hetimop"

# Install requirements
COPY requirements_deb .
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends  $(sed -e '/^#/d' requirements_deb) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./config/wrapper_metrics ./config/*.sh /app/scripts/
COPY ./config/pwn /etc/xinetd.d/pwn
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /app/scripts/* && \
    chmod +x /usr/local/bin/entrypoint.sh

CMD [ "/usr/local/bin/entrypoint.sh"]
