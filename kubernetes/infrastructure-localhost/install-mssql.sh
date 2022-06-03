NAMESPACE=mssql
MSSQL_NAME=my-mssql-linux

helm repo remove mssql-server-2019
helm repo add mssql-server-2019 https://simcubeltd.github.io/simcube-helm-charts/

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

# kubectl apply -f mssql/onenode-mssql-pv.yml
# kubectl apply -f mssql/onenode-mssql-deployment.yml
helm upgrade ${MSSQL_NAME} mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml --install --version 1.0.8