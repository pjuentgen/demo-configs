#!/bin/sh

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install ksm prometheus-community/kube-state-metrics 

helm install nodeexporter prometheus-community/prometheus-node-exporter


kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN
kubectl apply -f collector-configmap.yaml
kubectl apply -f service-account.yaml
kubectl apply -f clusterrole.yaml
kubectl apply -f clusterrolebinding.yaml
kubectl apply -f collector-deployment.yaml
kubectl apply -f collector-service.yaml

kubectl apply -f otel-instrumentation.yaml

