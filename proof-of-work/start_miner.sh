#!/bin/bash
set -e

DATADIR=/root/.ethereum
NETWORKID=987

echo "Running miner node..."

# Init with genesis if datadir not initialized
if [ ! -d "$DATADIR/geth/chaindata" ] || [ -z "$(ls -A $DATADIR/geth/chaindata 2>/dev/null)" ]; then
    echo "Initializing node with genesis.json..."
    geth --datadir $DATADIR init /root/genesis.json
else
    echo "Datadir already initialized, skipping genesis init."
fi

# Create account if it does not exist
if [ -z "$(ls -A $DATADIR/keystore 2>/dev/null)" ]; then
    echo "Creating account..."
    geth account new --datadir $DATADIR --password /root/password.txt
    sleep 1
fi

# Find the first account in keystore
ETHERBASE=$(geth --datadir $DATADIR account list | grep -o '{.*}' | tr -d '{}' | head -n1)
echo "Using etherbase: $ETHERBASE"

# Start geth with miner parameters
exec geth --datadir $DATADIR \
          --networkid $NETWORKID \
          --http --http.addr "0.0.0.0" \
          --http.port $HTTP_PORT \
          --http.api eth,net,web3,personal,miner,admin,txpool,debug,clique \
          --http.vhosts="*" \
          --allow-insecure-unlock \
          --unlock $ETHERBASE \
          --mine \
          --miner.threads 1 \
          --miner.etherbase $ETHERBASE \
          --password /root/password.txt \
          --nat "any" \
          --port $P2P_PORT \
          --nodekey /root/.ethereum/geth/nodekey \
          --verbosity 1 \
          --nodiscover \
          --config /root/config.toml
