NAMESPACE=ingress-controller
# DNS_LABEL=etreem-dev-aks

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl create namespace ${NAMESPACE}
kubectl config set-context --current --namespace=$NAMESPACE

helm upgrade -f values.yml ingress-nginx ingress-nginx/ingress-nginx --install