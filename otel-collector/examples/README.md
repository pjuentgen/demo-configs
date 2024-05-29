Easy way to roll this out:
```
kubectl create configmap otelcontribcol-cofigmap --from-file config.yaml=otel-collector/examples/k8s-collector-config.yaml  -o yaml --dry-run=client | kubectl apply -f - && kubectl label configmap otelcontribcol-cofigmap app=otelcontribcol && kubectl rollout restart deployment otelcontribcol

```
