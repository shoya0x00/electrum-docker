FROM python:latest

# Environment Variables
ENV ELECTRUM_USER=electrum
ENV ELECTRUM_PASSWORD=electrumz
ENV ELECTRUM_HOME=/home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK=mainnet

# Add Electrum user and create necessary directories
RUN useradd -m -s /bin/bash $ELECTRUM_USER && \
    mkdir -p /data ${ELECTRUM_HOME} && \
    ln -sf /data ${ELECTRUM_HOME}/.electrum && \
    chown -R ${ELECTRUM_USER}:${ELECTRUM_USER} ${ELECTRUM_HOME} /data

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsecp256k1-0 \
    libsecp256k1-dev \
    libssl-dev \
    python3-pip \
    wget && \
    wget https://download.electrum.org/4.5.8/Electrum-4.5.8.tar.gz && \
    pip install --no-cache-dir cryptography pycryptodomex Electrum-4.5.8.tar.gz && \
    rm -f Electrum-4.5.8.tar.gz && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure Electrum directories exist
RUN mkdir -p ${ELECTRUM_HOME}/.electrum/wallets/ \
    ${ELECTRUM_HOME}/.electrum/testnet/wallets/ \
    ${ELECTRUM_HOME}/.electrum/regtest/wallets/ \
    ${ELECTRUM_HOME}/.electrum/simnet/wallets/ && \
    ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
    chown -R ${ELECTRUM_USER}:${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

# Switch to Electrum user
USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

# Copy and set permissions for entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
