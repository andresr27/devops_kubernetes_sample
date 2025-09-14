#!/bin/bash

echo "=== Monitoring Stack Validation ==="

# Check if services are running
echo -e "\n 1. Checking pod status..."
kubectl get pods -n monitoring

echo -e "\n2. Checking service status..."
kubectl get svc -n monitoring

echo -e "\n3. Checking ingress status..."
kubectl get ingress -n monitoring

# Test connectivity to Prometheus
echo -e "\n4. Testing Prometheus connectivity..."
PROMETHEUS_POD=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090 &
curl -s http://localhost:9090/status
kill 1

# Test connectivity to Zabbix
echo -e "\n5. Testing Zabbix connectivity..."
ZABBIX_POD=$(kubectl get pods -n monitoring -l app=zabbix-web -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n monitoring $ZABBIX_POD -- curl -s http://localhost:80/ > /dev/null && echo "Zabbix web is accessible"

# Test local DNS resolution
echo -e "\n6. Testing local DNS resolution..."
for host in prometheus.minikube.local grafana.minikube.local alertmanager.minikube.local zabbix.minikube.local; do
  if ping -c 1 $host &> /dev/null; then
    echo "$host resolves to $(dig +short $host)"
  else
    echo "Warning: $host does not resolve correctly"
  fi
done

echo -e "\n7. Testing web access..."
echo "Prometheus: http://prometheus.minikube.local"
echo "Zabbix: http://zabbix.minikube.local (Admin/zabbix)"

echo "=== Validation Complete ==="