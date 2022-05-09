helmfile --file helmfile.yaml -n %1 destroy
kubectl delete namespace %1
