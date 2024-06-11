Easy way to roll this out:
```
kubectl create configmap otel-collector-cofigmap --from-file config.yaml=otel-collector/examples/k8s-collector-config.yaml  -o yaml --dry-run=client | kubectl apply -f - && kubectl label configmap otel-collector-cofigmap app=otel-collector && kubectl rollout restart deployment otel-collector

```
