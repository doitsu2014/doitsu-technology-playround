NAMESPACE=opensearch
kubectl create namespace ${NAMESPACE}

kubectl apply -f ingress-opensearch.yml --namespace=${NAMESPACE}
kubectl get ingress --namespace=${NAMESPACE}