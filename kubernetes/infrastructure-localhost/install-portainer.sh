NAMESPACE=monitoring
PORTAINER_NAME=portainer-service
PORTAINER_WP=portainer

bash ./helm-repository.init.sh

kubectl create namespace $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

helm upgrade ${PORTAINER_NAME} portainer/portainer -f ${PORTAINER_WP}/default-value.yml --install