SERVER_NAME=elasticsearch
KIBANA_NAME=elasticsearch-kibana
NAMESPACE=elasticsearch

helm delete ${SERVER_NAME} --namespace=${NAMESPACE}
helm delete ${KIBANA_NAME} --namespace=${NAMESPACE}
kubectl delete -f ingress.yml --namespace=${NAMESPACE}
kubectl delete -f ingress-kibana.yml --namespace=${NAMESPACE}