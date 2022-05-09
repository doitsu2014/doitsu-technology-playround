NAMESPACE=infrastructure
REDIS_NAME=redis-server
REDIS_WP=redis

# helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm repo add bitnami https://charts.bitnami.com/bitnami

helm uninstall ${REDIS_NAME} 
helm install ${REDIS_NAME} -f ${REDIS_WP}/global-value.yml bitnami/redis
