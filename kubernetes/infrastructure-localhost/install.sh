NAMESPACE=infrastructure
OPENSEARCH_NAME=opensearch
OPENSEARCH_DASHBOARD_NAME=opensearch-dashboard
JAEGER_NAME=jaeger
REDIS_NAME=redis-server
MSSQL_NAME=my-mssql-linux
PORTAINER_NAME=portainer

OPENSEARCH_WP=opensearch
JAEGER_WP=jaeger
REDIS_WP=redis

CERTIFICATES=certificates

bash ./helm-repository.init.sh

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

kubectl delete secrets opensearch-internal-users-config --ignore-not-found=false
kubectl delete secrets opensearch-internal-roles-mapping-config --ignore-not-found=false
kubectl delete secrets opensearch-internal-roles-config --ignore-not-found=false
kubectl delete secrets opensearch-dashboard-credential --ignore-not-found=false
kubectl create secret generic opensearch-internal-users-config --from-file=$OPENSEARCH_WP/secret-configs/internal_users.yml
kubectl create secret generic opensearch-internal-roles-mapping-config --from-file=$OPENSEARCH_WP/secret-configs/roles_mapping.yml
kubectl create secret generic opensearch-internal-roles-config --from-file=$OPENSEARCH_WP/secret-configs/roles.yml
kubectl create secret generic opensearch-dashboard-credential --from-literal username=kibanaserver --from-literal password=zaQ@1234 --from-literal cookie=999977772222

rm -R $CERTIFICATES/*
bash ./generate-certificates.sh
kubectl delete secrets certificates --ignore-not-found=false
kubectl delete secrets opensearch-certificates --ignore-not-found=false
kubectl delete configmaps jaeger-tls --ignore-not-found=false
kubectl create secret generic certificates --from-file=$CERTIFICATES/
kubectl create secret generic opensearch-certificates --from-file=$CERTIFICATES/
kubectl create configmap jaeger-tls --from-file=$CERTIFICATES/

echo 'Sleep 5 seconds'
sleep 5 

helm upgrade ${JAEGER_NAME} --values ${JAEGER_WP}/jaeger-default-value.yml jaegertracing/jaeger --install
helm upgrade ${OPENSEARCH_NAME} -f ${OPENSEARCH_WP}/opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0 --install
helm upgrade ${OPENSEARCH_DASHBOARD_NAME} -f ${OPENSEARCH_WP}/opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1 --install
helm upgrade ${REDIS_NAME} -f ${REDIS_WP}/global-value.yml bitnami/redis --install
helm upgrade ${MSSQL_NAME} mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml --install --version 1.0.8
helm upgrade ${PORTAINER_NAME} portainer/portainer -f portainer/default-value.yml --install
