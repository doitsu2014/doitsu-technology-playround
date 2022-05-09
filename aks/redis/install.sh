NAMESPACE=redis
SERVER_NAME=redis-server

helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace ${NAMESPACE}
helm install ${SERVER_NAME} -f global-value.yml bitnami/redis --namespace ${NAMESPACE}