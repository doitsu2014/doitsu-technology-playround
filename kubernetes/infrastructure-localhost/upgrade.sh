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

helm repo add opensearch-project-helm-charts https://opensearch-project.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add portainer https://portainer.github.io/k8s
helm repo add mssql-server-2019 https://simcubeltd.github.io/simcube-helm-charts/

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm upgrade ${JAEGER_NAME} --values ${JAEGER_WP}/jaeger-default-value.yml jaegertracing/jaeger --install
helm upgrade ${OPENSEARCH_NAME} -f ${OPENSEARCH_WP}/opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0 --install
helm upgrade ${OPENSEARCH_DASHBOARD_NAME} -f ${OPENSEARCH_WP}/opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1 --install
helm upgrade ${REDIS_NAME} -f ${REDIS_WP}/global-value.yml bitnami/redis --install
helm upgrade ${MSSQL_NAME} mssql-server-2019/mssql-linux -f mssql/mssql-default-value.yml --install
helm upgrade ${PORTAINER_NAME} portainer/portainer -f portainer/default-value.yml --install