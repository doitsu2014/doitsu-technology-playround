NAMESPACE=infrastructure

OPENSEARCH_WP=opensearch
JAEGER_WP=jaeger
REDIS_WP=redis

kubectl create namespace ${NAMESPACE}

kubectl apply -f ${OPENSEARCH_WP}/ingress-opensearch.yml --namespace=${NAMESPACE}
kubectl get ingress --namespace=${NAMESPACE}