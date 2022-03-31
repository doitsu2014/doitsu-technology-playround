SERVER_NAME=elasticsearch
KIBANA_NAME=elasticsearch-kibana
NAMESPACE=elasticsearch

helm delete ${SERVER_NAME} --namepsace=${NAMESPACE}
helm delete ${KIBANA_NAME} --namepsace=${NAMESPACE}
