kubectl apply --namespace otel-demo -f https://raw.githubusercontent.com/open-telemetry/opentelemetry-demo/main/kubernetes/opentelemetry-demo.yaml


kubectl create configmap opentelemetry-demo-otelcol --from-file config.yaml=otel-collector/examples/otel-demo-collector-config.yaml -n otel-demo -o yaml --dry-run=client | kubectl apply -f -