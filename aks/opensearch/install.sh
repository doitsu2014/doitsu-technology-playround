SERVER_NAME=opensearch
DASHBOARD_SERVER_NAME=opensearch-dashboard
NAMESPACE=opensearch

helm repo add opensearch-project-helm-charts https://opensearch-project.github.io/helm-charts

kubectl create namespace ${NAMESPACE}
helm install ${SERVER_NAME} -f opensearch-default-value.yml opensearch-project-helm-charts/opensearch --version 1.9.0 --namespace=${NAMESPACE}
helm install ${DASHBOARD_SERVER_NAME} -f opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1 --namespace=${NAMESPACE}
