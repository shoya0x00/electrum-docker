FROM python:alpine

# Environment Variables
ENV ELECTRUM_USER=electrum
ENV ELECTRUM_HOME=/home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK=mainnet

# Add Electrum user and create necessary directories
RUN adduser -D -s /bin/bash $ELECTRUM_USER && \
    mkdir -p /data ${ELECTRUM_HOME} && \
    ln -sf /data ${ELECTRUM_HOME}/.electrum && \
    chown -R ${ELECTRUM_USER}:${ELECTRUM_USER} ${ELECTRUM_HOME} /data

# Install dependencies using Alpine's package manager (apk)
RUN apk update && apk add --no-cache \
    build-base \
    musl \
    gcc \
    libsecp256k1 \
    libsecp256k1-dev \
    openssl-dev \
    python3-dev \
    py3-pip \
    wget && \
    wget https://download.electrum.org/4.5.8/Electrum-4.5.8.tar.gz && \
    python3 -m pip install --no-cache-dir cryptography pycryptodomex Electrum-4.5.8.tar.gz && \
    rm -f Electrum-4.5.8.tar.gz && \
    apk del build-base musl gcc && \
    rm -rf /var/cache/apk/*

# Switch to Electrum user
USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

# Copy and set permissions for entrypoint
COPY entrypoint.sh /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
