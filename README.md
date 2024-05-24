# demo-configs

# /k8s

## /otel-getting-started
This contains all files to setup a demo environment to send data to Dash0

### Patch for Mac OS Docker Desktop
`kubectl patch ds nodeexporter-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'`

## /demo-app
Starts a demo app that can be auto-instrumented


