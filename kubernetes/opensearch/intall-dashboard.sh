DASHBOARD_SERVER_NAME=opensearch-dashboard
helm install ${DASHBOARD_SERVER_NAME} -f opensearch-dashboard-default-value.yml opensearch-project-helm-charts/opensearch-dashboards --version 1.3.1