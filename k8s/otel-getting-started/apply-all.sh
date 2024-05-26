#!/bin/sh

## check if certmanager is installed and if it it is installed, contineu. Otherwise apply the yaml file
kubectl get ns cert-manager || kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml

## check if opentelemetry-operator is installed and if it it is installed, contineu. Otherwise apply the yaml file
kubectl get ns opentelemetry-operator || kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install ksm prometheus-community/kube-state-metrics 

helm install nodeexporter prometheus-community/prometheus-node-exporter

# check if secret named dash0-secrets exists and if environment variable DASH0_AUTHORIZATION_TOKEN is set, if secret does not exist, but env var is set, create the secret
kubectl get secret dash0-secrets || [ -z "$DASH0_AUTHORIZATION_TOKEN" ] || kubectl create secret generic dash0-secrets --from-literal=dash0-authorization-token=$DASH0_AUTHORIZATION_TOKEN

kubectl apply -f collector-configmap.yaml
kubectl apply -f service-account.yaml
kubectl apply -f clusterrole.yaml
kubectl apply -f clusterrolebinding.yaml
kubectl apply -f collector-deployment.yaml
kubectl apply -f collector-service.yaml

## check if otel operator is already running and then apply the next yaml file
kubectl get otelcol otelcol -n opentelemetry || kubectl apply -f otelcol.yaml


kubectl get customresourcedefinitions.apiextensions.k8s.io instrumentations.opentelemetry.io  && kubectl apply -f otel-instrumentation.yaml

