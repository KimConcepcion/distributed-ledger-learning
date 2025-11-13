#!/bin/bash
set -e

DATADIR=/root/.ethereum
NETWORKID=987

echo "Running client node..."

# Init with genesis if datadir not initialized
if [ ! -d "$DATADIR/geth/chaindata" ] || [ -z "$(ls -A $DATADIR/geth/chaindata 2>/dev/null)" ]; then
    echo "Initializing node with genesis.json..."
    geth --datadir $DATADIR init /root/genesis.json
else
    echo "Datadir already initialized, skipping genesis init."
fi

# Start geth with client parameters
exec geth --datadir $DATADIR \
          --networkid $NETWORKID \
          --http \
          --http.addr "0.0.0.0" \
          --http.port $HTTP_PORT \
          --http.api eth,net,web3,admin,personal \
          --http.vhosts="*" \
        #   --syncmode "light" \
          --allow-insecure-unlock \
          --nat "any" \
          --verbosity 1 \
          --nodiscover \
          --config /root/config.toml
