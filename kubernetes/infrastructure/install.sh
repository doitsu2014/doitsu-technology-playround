NAMESPACE=infrastructure
OPENSEARCH_NAME=opensearch
OPENSEARCH_DASHBOARD_NAME=opensearch-dashboard
JAEGER_NAME=jaeger
REDIS_NAME=redis-server

OPENSEARCH_WP=opensearch
JAEGER_WP=jaeger
REDIS_WP=redis

CERTIFICATES=certificates

helm repo add opensearch-project-helm-charts https://opensearch-project.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

kubectl delete secrets opensearch-internal-users-config
kubectl delete secrets opensearch-internal-roles-mapping-config
kubectl delete secrets opensearch-internal-roles-config
kubectl delete secrets opensearch-dashboard-credential
kubectl create secret generic opensearch-internal-users-config --from-file=$OPENSEARCH_WP/secret-configs/internal_users.yml
kubectl create secret generic opensearch-internal-roles-mapping-config --from-file=$OPENSEARCH_WP/secret-configs/roles_mapping.yml
kubectl create secret generic opensearch-internal-roles-config --from-file=$OPENSEARCH_WP/secret-configs/roles.yml
kubectl create secret generic opensearch-dashboard-credential --from-literal username=kibanaserver --from-literal password=zaQ@1234 --from-literal cookie=999977772222

rm -R $CERTIFICATES/*
bash generate-certificates.sh
kubectl delete secrets certificates
kubectl delete secrets opensearch-certificates
kubectl delete configmaps jaeger-tls
kubectl create secret generic certificates --from-file=$CERTIFICATES/
kubectl create secret generic opensearch-certificates --from-file=$CERTIFICATES/
kubectl create configmap jaeger-tls --from-file=$CERTIFICATES/

helm install ${JAEGER_NAME} --values ${JAEGER_WP}/jaeger-default-value.yml jaegertracing/jaeger
helm install ${OPENSEARCH_NAME} -f ${OPENSEARCH_WP}/opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0
helm install ${OPENSEARCH_DASHBOARD_NAME} -f ${OPENSEARCH_WP}/opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1
helm install ${REDIS_NAME} -f ${REDIS_WP}/global-value.yml bitnami/redis --namespace ${NAMESPACE}

bash install-ingress.sh