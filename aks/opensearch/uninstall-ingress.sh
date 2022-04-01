NAMESPACE=opensearch
kubectl create namespace ${NAMESPACE}

kubectl delete -f ingress-opensearch.yml --namespace=${NAMESPACE}