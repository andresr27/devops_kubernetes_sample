# !/usr/bin/env python3

import requests
import json
import os
import time
import sys
from kubernetes import client, config


def validate_canary():
    # Load Kubernetes config
    try:
        config.load_incluster_config()  # When running inside cluster
    except:
        config.load_kube_config()  # When running locally

    v1 = client.CoreV1Api()

    # Get canary pods
    canary_pods = v1.list_namespaced_pod(
        namespace=os.getenv('K8S_NAMESPACE', 'default'),
        label_selector="track=canary"
    )

    if not canary_pods.items:
        print("No canary pods found!")
        return False

    # Test each canary pod
    success_count = 0
    for pod in canary_pods.items:
        pod_name = pod.metadata.name
        print(f"Testing canary pod: {pod_name}")

        try:
            # Execute health check inside the pod
            resp = requests.get(f"http://{pod.status.pod_ip}:8080/health", timeout=5)
            if resp.status_code == 200:
                print(f"✓ Pod {pod_name} health check passed")
                success_count += 1
            else:
                print(f"✗ Pod {pod_name} health check failed: HTTP {resp.status_code}")
        except Exception as e:
            print(f"✗ Pod {pod_name} health check error: {str(e)}")

    # Determine if canary is successful
    success_rate = success_count / len(canary_pods.items) if canary_pods.items else 0
    print(f"Canary success rate: {success_rate:.2%}")

    return success_rate >= 0.8  # Require 80% success rate


if __name__ == "__main__":
    # Wait a bit for pods to stabilize
    time.sleep(30)

    # Run validation
    if validate_canary():
        print("Canary validation passed!")
        sys.exit(0)
    else:
        print("Canary validation failed!")
        sys.exit(1)
