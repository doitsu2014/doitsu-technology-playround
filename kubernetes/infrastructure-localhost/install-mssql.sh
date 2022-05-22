NAMESPACE=infrastructure
MSSQL_NAME=my-mssql-linux

helm repo add mssql-server-2019 https://simcubeltd.github.io/simcube-helm-charts/
helm repo update

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm uninstall ${MSSQL_NAME}
helm install ${MSSQL_NAME} mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml