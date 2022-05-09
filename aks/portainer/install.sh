NAMESPACE=portainer

kubectl create namespace ${NAMESPACE}
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm install -n ${NAMESPACE} portainer portainer/portainer --set service.type=NodePort
kubectl apply ingress.yml --namespace=${NAMESPACE}