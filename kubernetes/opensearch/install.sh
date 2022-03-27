SERVER_NAME=opensearch
# helm install ${SERVER_NAME} --set service.type=LoadBalancer \
# --set replicas=1 \
#  opensearch-project-helm-charts/opensearch --version 1.9.0

helm install ${SERVER_NAME} -f opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0 