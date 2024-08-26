## Option 1: Manifest file
````
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml
````

## Option 2: Helm Chart 
````
helm repo add jetstack https://charts.jetstack.io --force-update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true
````


helm upgrade --install opentelemetry-operator open-telemetry/opentelemetry-operator --set "manager.collectorImage.repository=otel/opentelemetry-collector-k8s" --namespace opentelemetry --create-namespace
````
EXPORT THE KEY

````
export DASH0_AUTHORIZATION_TOKEN=xyz
kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN --namespace opentelemetry


kubectl apply -f collector-extended-crd.yaml

helm install my-prometheus-stack prometheus-community/kube-prometheus-stack
kubectl patch ds my-prometheus-stack-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'

````
