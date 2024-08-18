# https://docs.fluentbit.io/manual/pipeline/outputs/opentelemetry


# Deploying using heml
```
kubectl create namespace opentelemetry
kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN --namespace opentelemetry
```

```
helm repo add fluent https://fluent.github.io/helm-charts
helm upgrade --install --namespace opentelemetry  -f values.yaml fluent-bit fluent/fluent-bit
```
