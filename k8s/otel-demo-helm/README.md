```
export DASH0_AUTHORIZATION_TOKEN=auth_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN

helm install my-otel-demo open-telemetry/opentelemetry-demo --values otel-demo-values.yaml
```