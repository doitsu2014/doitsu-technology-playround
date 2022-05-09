NAMESPACE=infrastructure
MSSQL_NAME=my-mssql-linux

# helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm repo add mssql-server-2019 https://simcubeltd.github.io/mssql-server-helm/charts/

helm uninstall ${MSSQL_NAME}
helm install ${MSSQL_NAME} mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml