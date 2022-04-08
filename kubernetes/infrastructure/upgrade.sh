NAMESPACE=infrastructure
OPENSEARCH_NAME=opensearch
OPENSEARCH_DASHBOARD_NAME=opensearch-dashboard
JAEGER_NAME=jaeger
REDIS_NAME=redis-server

OPENSEARCH_WP=opensearch
JAEGER_WP=jaeger
REDIS_WP=redis

helm repo add opensearch-project-helm-charts https://opensearch-project.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm upgrade ${JAEGER_NAME} --values ${JAEGER_WP}/jaeger-default-value.yml jaegertracing/jaeger
helm upgrade ${OPENSEARCH_NAME} -f ${OPENSEARCH_WP}/opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0
helm upgrade ${OPENSEARCH_DASHBOARD_NAME} -f ${OPENSEARCH_WP}/opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1
helm upgrade ${REDIS_NAME} -f ${REDIS_WP}/global-value.yml bitnami/redis --namespace ${NAMESPACE}

bash install-ingress.sh