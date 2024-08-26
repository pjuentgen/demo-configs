https://github.com/prometheus-community/helm-charts

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install my-prometheus-stack prometheus-community/kube-prometheus-stack --namespace observability --create-namespace

OS X on M1:

kubectl patch ds my-prometheus-stack-prometheus-node-exporter -n observability --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'



Install OTel Operator with Collector
Make sure this is set:

  mode: daemonset
  targetAllocator:    
    enabled: true
    replicas: 1
    image: ghcr.io/open-telemetry/opentelemetry-operator/target-allocator:main    
    allocationStrategy: "per-node"    
    prometheusCR:
      enabled: true
      serviceMonitorSelector: {}
      podMonitorSelector: {}

Apply the right access rights:
kubectl apply -f RoleAndRoleBinding.yaml

Maybe restart target allocator service.

Go to target allocator service /jobs
And visite the scrape configs shown in the output