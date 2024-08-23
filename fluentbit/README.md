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


## Create configmap with configuration.yaml
## Change daemonset to use yaml configuration

kubectl create configmap fluent-bit-config --from-file=config.yaml --from-file=custom_parsers.conf --namespace opentelemetry
kubectl create configmap fluent-bit-lue-scripts --from-file=check_json.lua --namespace opentelemetry


values file: 
existingConfigMap

kubectl patch daemonset fluent-bit -n opentelemetry --type=json -p '[
  {
    "op": "replace",
    "path": "/spec/template/spec/containers/0/args/1",
    "value": "--config=/fluent-bit/etc/conf/config.yaml"
  }
]'

k delete configmap my-config --namespace opentelemetry && kubectl create configmap my-config --from-file=config.yaml --namespace opentelemetry && k rollout restart daemonset fluent-bit -n opentelemetry


kubectl patch daemonset fluent-bit -n opentelemetry --patch "$(cat fluent-bit-lua-patch.yaml)"