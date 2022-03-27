SERVER_NAME=redis-server
helm install ${SERVER_NAME} -f global-value.yml bitnami/redis