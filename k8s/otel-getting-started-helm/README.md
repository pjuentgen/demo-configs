## Adding the OpenTelemetry Helm Charts
```
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
```

## Deploying the OpenTelemetry Operator
Prerequisit is have cert manager installed
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml
```

```
helm install opentelemetry-operator open-telemetry/opentelemetry-operator --set "manager.collectorImage.repository=otel/opentelemetry-collector-k8s" --namespace opentelemetry --create-namespace
```

Before continuing we need to have the DASH0_AUTHORIZATION_TOKEN as secret (in the same namesapce)

```
kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN --namespace opentelemetry
```

Execuing the chart we can provide predefined values using the `-f` parameter:

## otel-collector-values.yaml
```
mode: daemonset
service:
  enabled: true
image:
  repository: "otel/opentelemetry-collector-contrib"

presets:
  logsCollection:
    enabled: true
    includeCollectorLogs: true
  kubernetesAttributes:
    enabled: true
    extractAllPodLabels: true
    extractAllPodAnnotations: true
  kubeletMetrics:
    enabled: true
  kubernetesEvents:
    enabled: true

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 64Mi


config:
  exporters:
    otlp/dash0:
      # auth:
        # authenticator: bearertokenauth/dash0
      endpoint: ingress.eu-west-1.aws.dash0.com:4317
      headers:
       Authorization: ${DASH0_AUTHORIZATION_TOKEN}
    debug: {}
  extensions:
    health_check:
      endpoint: ${env:MY_POD_IP}:13133
  processors:
    batch: {}
    memory_limiter: null
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: ${env:MY_POD_IP}:4317
        http:
          endpoint: ${env:MY_POD_IP}:4318
  service:
    telemetry:
      metrics:
        address: ${env:MY_POD_IP}:8888
    extensions:
      - health_check
      # - "bearertokenauth/dash0":
      #     scheme: Bearer
      #     token: ${env:DASH0_AUTHORIZATION_TOKEN}
    pipelines:
      logs:
        exporters:
          - otlp/dash0
        processors:
          - batch
        receivers:
          - otlp
      metrics:
        exporters:
          - otlp/dash0
        processors:
          - batch
        receivers:
          - otlp
          - prometheus
      traces:
        exporters:
          - otlp/dash0
        processors:
          - batch
        receivers:
          - otlp

extraEnvs:
 - name: DASH0_AUTHORIZATION_TOKEN
   valueFrom:
     secretKeyRef:
       name: dash0-secrets
       key: dash0-authorization-token
       optional: false

```

Now that we have prepared the values file we can execute the helm chart for the OpenTelemetry Operator.

```
helm install opentelemetry-collector open-telemetry/opentelemetry-collector -f otel-collector-values.yaml --namespace opentelemetry
```

We want to apply instrumentation to some of our workloads. The basic settings of that instrumetation are specified using the Instrumentation CRD.:

otel-instrumentation.yaml
```
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: otel-instrumentation
spec:
  exporter:
    endpoint: http://opentelemetry-collector.opentelemetry:4317
  propagators:
    - tracecontext
    - baggage
  sampler:
    type: always_on
    argument: "1"
```

That can be applied using the following command:
```
kubectl apply -f otel-instrumentation.yaml
```