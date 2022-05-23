NAMESPACE=mssql
MSSQL_NAME=my-mssql-linux

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

kubectl apply -f mssql/onenode-mssql-pv.yml
kubectl apply -f mssql/onenode-mssql-deployment.yml