#!/usr/bin/env sh
set -ex

# Determine network flags
case "$ELECTRUM_NETWORK" in
  testnet) FLAGS="--testnet" ;;
  testnet4) FLAGS="--testnet4" ;;
  regtest) FLAGS="--regtest" ;;
  simnet) FLAGS="--simnet" ;;
  signet) FLAGS="--signet" ;;
  *) FLAGS="" ;;
esac

# Remove Old Lockfile
rm -rf /data/daemon

# Set Electrum config
electrum --offline $FLAGS setconfig rpcuser "$ELECTRUM_USER"
electrum --offline $FLAGS setconfig rpcpassword "$ELECTRUM_PASSWORD"
electrum --offline $FLAGS setconfig rpchost 0.0.0.0
electrum --offline $FLAGS setconfig rpcport 7000

# Run Electrum daemon in foreground
exec electrum -v $FLAGS daemon
