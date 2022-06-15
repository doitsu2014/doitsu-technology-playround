NAMESPACE=ingress-controller

# Add the Jetstack Helm repository

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
kubectl create namespace ${NAMESPACE}
