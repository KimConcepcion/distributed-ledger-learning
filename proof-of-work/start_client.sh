#!/bin/bash
set -e

DATADIR=/root/.ethereum
NETWORKID=987

# Init with genesis if datadir not initialized
if [ ! -d "$DATADIR/geth/chaindata" ] || [ -z "$(ls -A $DATADIR/geth/chaindata 2>/dev/null)" ]; then
    echo "Initializing node with genesis.json..."
    geth --datadir $DATADIR init /root/genesis.json
else
    echo "Datadir already initialized, skipping genesis init."
fi

# Start geth - mine right away with 1 thread
exec geth --datadir $DATADIR \
          --http \
          --http.addr "0.0.0.0" \
          --http.port $HTTP_PORT \
          --http.api eth,net,web3 \
          --http.vhosts="*" \
          --syncmode "light" \
          --networkid $NETWORKID \
          --allow-insecure-unlock \
          --nat "any" \
          --verbosity 4 \
          --nodiscover \
          --config /root/config.toml
