#!/usr/bin/env bash
set -e
SOLR_VER=${SOLR_VER:-9.3}
ZK_VER=${ZK_VER:-3.9}
NET=solr-dev-net
SOLR_PORT=${SOLR_PORT:-8983}
ZK_PORT=2181

# ZK first, then Solr in cloud mode
echo "Bringing up ZK then Solr on ports $ZK_PORT and $SOLR_PORT ..."

docker network create $NET 2>/dev/null || true

docker run -d --rm --network $NET --name zk -p $ZK_PORT:2181 \
  -e ZOOKEEPER_CLIENT_PORT=2181 \
  -e ZOOKEEPER_TICK_TIME=2000 \
  apache/zookeeper:${ZK_VER}

sleep 3

docker run -d --rm --network $NET --name solr -p $SOLR_PORT:8983 \
  -e SOLR_OPTS="-DzkHost=zk:2181" \
  solr:${SOLR_VER} solr start -f -c -z zk:2181

echo "Waiting for Solr..."
for i in $(seq 1 30); do
  if curl -s "http://localhost:$SOLR_PORT/solr/admin/collections?action=CLUSTERSTATUS&wt=json" >/dev/null 2>&1; then
    echo "Solr ready at http://localhost:$SOLR_PORT/solr"
    echo "ZK at localhost:$ZK_PORT. To stop: docker stop solr zk"
    exit 0
  fi
  sleep 2
done
echo "Solr may still be starting; check http://localhost:$SOLR_PORT/solr"
exit 0
