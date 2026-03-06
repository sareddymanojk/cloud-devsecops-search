#!/usr/bin/env bash
# Set INDEX_NAME and either OPENSEARCH_ENDPOINT or SOLR_URL.
# e.g. INDEX_NAME=myindex OPENSEARCH_ENDPOINT=https://... ./validate-index-shards.sh

set -e
INDEX_NAME=${INDEX_NAME:?set INDEX_NAME}
OPENSEARCH_ENDPOINT=${OPENSEARCH_ENDPOINT:-}
SOLR_URL=${SOLR_URL:-}

if [[ -n "$OPENSEARCH_ENDPOINT" ]]; then
  BASE="${OPENSEARCH_ENDPOINT%/}"
  HEALTH=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/_cluster/health" || echo "000")
  if [[ "$HEALTH" != "200" ]]; then
    echo "Cluster health check failed (HTTP $HEALTH)"
    exit 1
  fi
  COUNT=$(curl -s "$BASE/${INDEX_NAME}/_count" | jq -r '.count // empty')
  SHARDS=$(curl -s "$BASE/_cat/shards/${INDEX_NAME}?h=state,prirep" 2>/dev/null | wc -l)
  echo "Index $INDEX_NAME: count=$COUNT, shards=$SHARDS"
  if [[ -z "$COUNT" && -z "$SHARDS" ]]; then
    echo "Index missing or inaccessible"
    exit 1
  fi
elif [[ -n "$SOLR_URL" ]]; then
  BASE="${SOLR_URL%/}"
  STATUS=$(curl -s "$BASE/solr/admin/collections?action=CLUSTERSTATUS&wt=json" | jq -r ".cluster.collections.\"${INDEX_NAME}\" // empty")
  if [[ -z "$STATUS" ]]; then
    echo "Collection $INDEX_NAME not found"
    exit 1
  fi
  echo "Collection $INDEX_NAME found; shards: $(echo "$STATUS" | jq -r '.shards | keys | join(", ")')"
else
  echo "Set OPENSEARCH_ENDPOINT or SOLR_URL"
  exit 1
fi
