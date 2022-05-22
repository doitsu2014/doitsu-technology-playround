SERVER_NAME=elasticsearch
KIBANA_NAME=kibana-service
ECK_NAME=elasticsearch-eck
NAMESPACE=elasticsearch
ELASTIC_PASSWORD=zaQ@1234

helm repo add elastic https://helm.elastic.co
kubectl create namespace ${NAMESPACE}

helm install ${SERVER_NAME} -f elasticsearch-default-value.yml elastic/elasticsearch --version 7.17.1 --namespace=${NAMESPACE}
# kubectl apply -f ingress.yml --namespace=${NAMESPACE}

helm install ${KIBANA_NAME} -f elasticsearch-kibana-default-value.yml elastic/kibana --version 7.17.1 --namespace=${NAMESPACE}
# kubectl apply -f ingress-kibana.yml --namespace=${NAMESPACE}