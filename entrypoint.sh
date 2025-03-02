#!/usr/bin/env sh
set -ex

# Determine network flags
case "$ELECTRUM_NETWORK" in
  mainnet) FLAGS="--mainnet" ;;
  testnet) FLAGS="--testnet" ;;
  regtest) FLAGS="--regtest" ;;
  simnet) FLAGS="--simnet" ;;
  *) FLAGS="" ;;
esac

# Set Electrum config
electrum --offline $FLAGS setconfig rpcuser "$ELECTRUM_USER"
electrum --offline $FLAGS setconfig rpcpassword "$ELECTRUM_PASSWORD"
electrum --offline $FLAGS setconfig rpchost 0.0.0.0
electrum --offline $FLAGS setconfig rpcport 7000

# Run Electrum daemon in foreground
exec electrum $FLAGS daemon
