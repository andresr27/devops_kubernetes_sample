# Middleware:

## Overview

This document provides instructions for deploying and validating the monitoring stack (Prometheus, Zabbix, and Fluent Bit) on Kubernetes using Helm.

## Middleware Strategy

### Development Environment (Minikube or Docker Desktop)
Our development environment runs on Minikube with self-hosted services:

```
middleware/
└── dev/
    └── kubernetes/
        ├── fluent-bit/      # Log collection and forwarding
        ├── prometheus/      # Metrics collection and monitoring
        └── zabbix/          # Additional monitoring and alerting
```


## Prerequisites

- Kubernetes cluster (Minikube for development, managed Kubernetes for production)
- Helm 3.x installed
- kubectl configured to access your cluster
- Ingress controller enabled (for web access)

## Monitoring Stack Deployment Guide

### 1. Create Monitoring Namespace
```bash
kubectl create namespace monitoring
```

### 2. Deploy Prometheus Stack
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values values-zabbix.yaml \
  --wait --timeout 300s
```

### 3. Deploy Zabbix
```bash
helm repo add cetic https://cetic.github.io/helm-charts
helm repo update

helm install zabbix cetic/zabbix \
  --namespace monitoring \
  --values values-zabbix.yaml \
  --wait --timeout 300s
```

### 4. Deploy Fluent Bit
```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

# Create OpenSearch authentication secret
kubectl create secret generic opensearch-auth --namespace monitoring \
  --from-literal=username=admin \
  --from-literal=password=your-secure-password-here

helm install fluent-bit fluent/fluent-bit \
  --namespace monitoring \
  --values values-fluentbit.yaml \
  --wait --timeout 300s
```

### 5. Apply Ingress Resources
```bash
kubectl apply -f ingress-prometheus.yaml -n monitoring
kubectl apply -f ingress-zabbix.yaml -n monitoring
```

## Production Deployment Considerations

### Critical Parameters for Production

1. **Storage Configuration**:
   ```yaml
   # Increase storage sizes for production
   storageSpec:
     volumeClaimTemplate:
       spec:
         storageClassName: gp2-encrypted  # Use encrypted storage
         accessModes: ["ReadWriteOnce"]
         resources:
           requests:
             storage: 100Gi  # Increase from 20Gi to 100Gi
   ```

2. **Resource Limits**:
   ```yaml
   # Increase resource limits for production
   resources:
     requests:
       memory: 2Gi  # Increase from 512Mi
       cpu: 1000m   # Increase from 250m
     limits:
       memory: 4Gi  # Increase from 2Gi
       cpu: 2000m   # Increase from 1
   ```

3. **High Availability**:
   ```yaml
   # Enable high availability in production
   highAvailability:
     enabled: true
     replicaCount: 3
   ```

4. **Security Hardening**:
   ```yaml
   # Production security settings
   securityContext:
     runAsNonRoot: true
     runAsUser: 1000
     fsGroup: 1000
   serviceAccount:
     create: true
     name: monitoring-service-account
   ```

5. **External Authentication**:
   ```yaml
   # Add OAuth or other authentication for production
   grafana:
     env:
       GF_AUTH_GENERIC_OAUTH_ENABLED: "true"
       GF_AUTH_GENERIC_OAUTH_CLIENT_ID: "$CLIENT_ID"
       GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET: "$CLIENT_SECRET"
   ```

## Service Interconnection Configuration

### 1. Prometheus to Scrape Zabbix Metrics

Add to your `values-prometheus.yaml`:
```yaml
additionalScrapeConfigs:
  - job_name: 'zabbix'
    static_configs:
      - targets: ['zabbix-web.monitoring.svc.cluster.local:80']
    metrics_path: /metrics
    scrape_interval: 30s
```

### 2. Zabbix to Monitor Prometheus Components

Create a Zabbix template configuration:
```yaml
# zabbix-template-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: zabbix-prometheus-template
  namespace: monitoring
data:
  prometheus.xml: |
    <?xml version="1.0" encoding="UTF-8"?>
    <zabbix_export>
      <templates>
        <template>
          <template>Prometheus Monitoring</template>
          <items>
            <!-- Add Prometheus-specific items -->
          </items>
        </template>
      </templates>
    </zabbix_export>
```

### 3. Fluent Bit to Enrich Logs with Prometheus Metrics

Enhance your Fluent Bit configuration:
```yaml
filters: |
  [FILTER]
    Name          record_modifier
    Match         *
    Record        cluster_name ${KUBERNETES_CLUSTER_NAME}
    Record        environment ${ENVIRONMENT}
  
  [FILTER]
    Name          prometheus
    Match         kube.*
    Help          Kubernetes pod logs
    Type          counter
    Name          kube_logs_total
    Label         pod $kubernetes['pod_name']
    Label         namespace $kubernetes['namespace_name']
```

## Validation Procedures

### 1. Prometheus Stack Validation

**Check Pod Status**:
```bash
kubectl get pods -n monitoring -l "app.kubernetes.io/instance=prometheus"
```

**Verify Prometheus Targets**:
```bash
# Port forward to Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Check targets (should show "UP" status for all components)
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[].health'
```

**Validate Alertmanager**:
```bash
# Check Alertmanager status
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093
curl http://localhost:9093/api/v1/status
```

### 2. Zabbix Validation

**Check Zabbix Components**:
```bash
kubectl get pods -n monitoring -l "app=zabbix"

# Verify Zabbix server connectivity
kubectl exec -n monitoring deployment/zabbix-web -- curl -s http://zabbix-server:10051/status
```

**Test Zabbix API**:
```bash
# Get Zabbix API token
ZABBIX_TOKEN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"user.login","params":{"user":"Admin","password":"zabbix"},"id":1}' \
  http://zabbix-web.monitoring.svc.cluster.local/api_jsonrpc.php | jq -r '.result')

# Verify API functionality
curl -s -X POST -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"host.get\",\"params\":{\"output\":[\"hostid\",\"host\"]},\"id\":1,\"auth\":\"$ZABBIX_TOKEN\"}" \
  http://zabbix-web.monitoring.svc.cluster.local/api_jsonrpc.php
```

### 3. Fluent Bit Validation

**Check Fluent Bit Status**:
```bash
kubectl get pods -n monitoring -l "app.kubernetes.io/instance=fluent-bit"

# View Fluent Bit logs
kubectl logs -n monitoring -l "app.kubernetes.io/instance=fluent-bit" --tail=50
```

**Verify OpenSearch Connection**:
```bash
# Check if Fluent Bit can reach OpenSearch
kubectl exec -n monitoring deployment/fluent-bit -- curl -s -u admin:password \
  http://opensearch-cluster-master.monitoring.svc.cluster.local:9200/_cluster/health
```

**Test Log Processing**:
```bash
# Send a test log message
kubectl exec -n monitoring deployment/fluent-bit -- sh -c \
  'echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"INFO\",\"message\":\"Test message from validation\"}" >> /var/log/containers/test.log'

# Check if it appears in OpenSearch (after a few seconds)
curl -s -u admin:password \
  "http://opensearch-cluster-master.monitoring.svc.cluster.local:9200/fluentbit-*/_search?q=message:test" | jq '.hits.hits[]._source'
```

### 4. End-to-End Validation

**Create Test Application**:
```yaml
# test-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-monitoring-app
  namespace: default
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test-monitoring-app
  template:
    metadata:
      labels:
        app: test-monitoring-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
    spec:
      containers:
      - name: test-app
        image: busybox #This is so cool!
        command: ["/bin/sh"]
        args: ["-c", "while true; do echo '{\"level\":\"INFO\",\"message\":\"Test log message\"}'; sleep 30; done"]
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: test-monitoring-app
  namespace: default
spec:
  selector:
    app: test-monitoring-app
  ports:
  - port: 8080
    targetPort: 8080
```

**Deploy and Verify**:
```bash
kubectl apply -f test-app.yaml

# Check if Prometheus discovers the target
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.job == "default/test-monitoring-app")'

# Check if logs appear in OpenSearch
curl -s -u admin:password \
  "http://opensearch-cluster-master.monitoring.svc.cluster.local:9200/fluentbit-default/_search?q=app:test-monitoring-app" | jq '.hits.total.value'
```

## Troubleshooting Common Issues

1. **Prometheus Targets Down**:
    - Check service discovery annotations
    - Verify network policies allow scraping
    - Check if metrics endpoints are accessible

2. **Fluent Bit Not Shipping Logs**:
    - Verify OpenSearch connection details
    - Check authentication credentials
    - Review Fluent Bit configuration maps

3. **Zabbix Not Collecting Data**:
    - Verify agent communication
    - Check firewall rules
    - Review Zabbix server logs

4. **Resource Constraints**:
    - Monitor resource usage: `kubectl top pods -n monitoring`
    - Adjust resource limits in values files if needed

## Maintenance and Updates

### Upgrade Procedures
```bash
# Upgrade Prometheus stack
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values values-prometheus.yaml

# Upgrade Zabbix
helm upgrade zabbix cetic/zabbix \
  --namespace monitoring \
  --values values-zabbix.yaml

# Upgrade Fluent Bit
helm upgrade fluent-bit fluent/fluent-bit \
  --namespace monitoring \
  --values values-fluentbit.yaml
```

### Backup Procedures
```bash
# Backup Prometheus data (if using persistent storage)
velero backup create monitoring-backup --include-namespaces monitoring

# Export Zabbix configuration
kubectl exec -n monitoring deployment/zabbix-server -- \
  zabbix-server -c /etc/zabbix/zabbix_server.conf -R config_cache_reload
```

## Support

For issues with the monitoring stack:
1. Check pod logs: `kubectl logs -n monitoring <pod-name>`
2. Verify resource allocation: `kubectl describe nodes`
3. Check network connectivity between components
4. Review Kubernetes events: `kubectl get events -n monitoring`

Contact the platform team for assistance with configuration changes or persistent issues.


# Configuring Zabbix with Prometheus on Minikube

I'll help you fix the deployment names and focus on Method 1 with local Minikube configuration. Let's create a clean solution that works with `.local` domains pointing to your Minikube cluster.

## Fixed Configuration Files

### 1. Updated values-zabbix.yaml

```yaml
# values-zabbix.yaml
zabbix-server:
  enabled: true
  image:
    tag: alpine-6.4.5
  resources:
    requests:
      memory: 512Mi
      cpu: 250m
    limits:
      memory: 1Gi
      cpu: 500m
  persistence:
    enabled: true
    storageClassName: standard
    size: 10Gi

zabbix-web:
  enabled: true
  image:
    tag: alpine-6.4.5
  resources:
    requests:
      memory: 256Mi
      cpu: 100m
    limits:
      memory: 512Mi
      cpu: 250m
  service:
    type: ClusterIP
  ingress:
    enabled: true
    hosts:
      - zabbix.minikube.local
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /

zabbix-agent:
  enabled: true
  resources:
    requests:
      memory: 64Mi
      cpu: 50m
    limits:
      memory: 128Mi
      cpu: 100m

postgresql:
  enabled: true
  auth:
    username: zabbix
    password: "zabbix-password"
    database: zabbix
  persistence:
    enabled: true
    storageClassName: standard
    size: 20Gi
  resources:
    requests:
      memory: 256Mi
      cpu: 250m
    limits:
      memory: 512Mi
      cpu: 500m

# Prometheus integration configuration
prometheus:
  enabled: true
  url: "http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090"
```

### 2. Updated values-prometheus.yaml

```yaml
# values-prometheus.yaml
prometheus:
  prometheusSpec:
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: standard
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 20Gi
    resources:
      requests:
        memory: 512Mi
        cpu: 250m
      limits:
        memory: 2Gi
        cpu: 1

prometheus-node-exporter:
  enabled: true

kube-state-metrics:
  enabled: true

# Ingress configuration for Prometheus
ingress:
  enabled: true
  hosts:
    - prometheus.minikube.local
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
```

### 3. Zabbix Prometheus Template ConfigMap

```yaml
# zabbix-prometheus-template.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: zabbix-prometheus-template
  namespace: monitoring
data:
  prometheus_template.xml: |
    <?xml version="1.0" encoding="UTF-8"?>
    <zabbix_export>
      <version>6.4</version>
      <date>2023-12-07T10:00:00Z</date>
      <templates>
      ...
      </templates>
    </zabbix_export>
```

## Installation Commands

### 1. Add Helm Repositories
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add cetic https://cetic.github.io/helm-charts
helm repo update
```

### 2. Create Monitoring Namespace
```bash
kubectl create namespace monitoring
```

### 3. Install Prometheus Stack
```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values values-prometheus.yaml \
  --wait --timeout 300s
```

### 4. Install Zabbix
```bash
helm install zabbix cetic/zabbix \
  --namespace monitoring \
  --values values-zabbix.yaml \
  --wait --timeout 300s
```

### 5. Apply the Prometheus Template
```bash
kubectl apply -f zabbix-prometheus-template.yaml -n monitoring
```

## Configure Local DNS for Minikube

### Update /etc/hosts File
Add these entries to your `/etc/hosts` file:

```
$(minikube ip) prometheus.minikube.local
$(minikube ip) zabbix.minikube.local
```

You can automate this with:
```bash
MINIKUBE_IP=$(minikube ip)
echo "$MINIKUBE_IP prometheus.minikube.local" | sudo tee -a /etc/hosts
echo "$MINIKUBE_IP zabbix.minikube.local" | sudo tee -a /etc/hosts
```

## Validation Script

Create a validation script `validate-monitoring.sh`:

```bash
#!/bin/bash

echo "=== Monitoring Stack Validation ==="

# Check if services are running
echo "1. Checking pod status..."
kubectl get pods -n monitoring

echo "2. Checking service status..."
kubectl get svc -n monitoring

echo "3. Checking ingress status..."
kubectl get ingress -n monitoring

# Test connectivity to Prometheus
echo "4. Testing Prometheus connectivity..."
PROMETHEUS_POD=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n monitoring $PROMETHEUS_POD -- curl -s http://localhost:9090/api/v1/status | jq '.data.ready'

# Test connectivity to Zabbix
echo "5. Testing Zabbix connectivity..."
ZABBIX_POD=$(kubectl get pods -n monitoring -l app=zabbix-web -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n monitoring $ZABBIX_POD -- curl -s http://localhost:80/ > /dev/null && echo "Zabbix web is accessible"

# Test local DNS resolution
echo "6. Testing local DNS resolution..."
for host in prometheus.minikube.local grafana.minikube.local alertmanager.minikube.local zabbix.minikube.local; do
  if ping -c 1 $host &> /dev/null; then
    echo "$host resolves to $(dig +short $host)"
  else
    echo "Warning: $host does not resolve correctly"
  fi
done

echo "7. Testing web access..."
echo "Prometheus: http://prometheus.minikube.local"
echo "Grafana: http://grafana.minikube.local (admin/prom-operator)"
echo "Alertmanager: http://alertmanager.minikube.local"
echo "Zabbix: http://zabbix.minikube.local (Admin/zabbix)"

echo "=== Validation Complete ==="
```

Make it executable and run it:
```bash
chmod +x validate-monitoring.sh
./validate-monitoring.sh
```

## Manual Validation Steps

### 1. Verify Prometheus is Working
```bash
# Check Prometheus targets
curl http://prometheus.minikube.local/api/v1/targets | jq '.data.activeTargets[].health'

# Check if Prometheus is scraping itself
curl "http://prometheus.minikube.local/api/v1/query?query=up{job=\"prometheus\"}"
```

### 2. Verify Zabbix is Working
```bash
# Check Zabbix API
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"user.login","params":{"user":"Admin","password":"zabbix"},"id":1}' \
  http://zabbix.minikube.local/api_jsonrpc.php | jq '.result'
```

### 3. Verify Zabbix Can Access Prometheus
```bash
# Test from within Zabbix server pod
ZABBIX_SERVER_POD=$(kubectl get pods -n monitoring -l app=zabbix-server -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n monitoring $ZABBIX_SERVER_POD -- \
  curl -s http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090/api/v1/status | jq '.data.ready'
```

### 4. Verify Template is Loaded
```bash
# Check if template is mounted in Zabbix server
kubectl exec -n monitoring $ZABBIX_SERVER_POD -- \
  ls -la /etc/zabbix/templates/
```

## Troubleshooting

If you encounter issues:

1. **Check Minikube IP has not changed**:
   ```bash
   minikube ip
   # Update /etc/hosts if needed
   ```

2. **Check Ingress Controller**:
   ```bash
   minikube addons enable ingress
   kubectl get pods -n ingress-nginx
   ```

3. **Check Services**:
   ```bash
   kubectl get svc -n monitoring
   # Ensure all services have ClusterIP or NodePort
   ```

4. **Check Pod Logs**:
   ```bash
   kubectl logs -n monitoring -l app=zabbix-server
   kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus
   ```

This configuration provides a complete monitoring stack on Minikube with proper local DNS resolution and integration between Zabbix and Prometheus.