NAMESPACE=infrastructure
OPENSEARCH_NAME=opensearch
OPENSEARCH_DASHBOARD_NAME=opensearch-dashboard
JAEGER_NAME=jaeger
REDIS_NAME=redis-server

# helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm repo add mssql-server-2019 https://simcubeltd.github.io/mssql-server-helm/charts/

helm install my-mssql-linux mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml --namespace=${NAMESPACE} 
