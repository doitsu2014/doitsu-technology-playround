SERVER_NAME=elasticsearch
KIBANA_NAME=elasticsearch-kibana
NAMESPACE=elasticsearch

helm delete ${SERVER_NAME} --namespace=${NAMESPACE}
helm delete ${KIBANA_NAME} --namespace=${NAMESPACE}
