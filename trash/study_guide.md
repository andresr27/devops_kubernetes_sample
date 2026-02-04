# Devops Study guide

##  Test Format (Coderbyte)

A 4-hour test on Coderbyte for a lead position will almost certainly be a **project-based assessment**.

*   **Coding:** Writing Python scripts for automation.
*   **Configuration:** Writing Dockerfiles, Kubernetes YAML manifests, CI/CD pipelines (GitHub Actions/GitLab CI), or configuration management scripts (e.g., Ansible).
*   **Architecture Design:** Answering open-ended questions about designing a system, troubleshooting a failure, or improving an existing infrastructure.
*   **Debugging:** You might be given a broken environment or code and asked to find and fix the issues.

---

### Strategic Preparation Plan

Given the time constraint, focus on the "Requirements" first, then the "Responsibilities", and finally the "Nice-to-haves".

#### 1. Core Concepts to Review (Architecture & Theory)

You need to be able to discuss these fluently. Think of the "why" behind every decision.

*   **Kubernetes (Advanced):**
    *   **Architecture:** Be able to draw and explain every component: API Server, etcd, Scheduler, Controller Manager, Kubelet, Kube-Proxy, Container Runtime. Know what happens from `kubectl apply` to a pod running.
    *   **Networking:**
        *   How does the **Pod Network** (CNI like Calico/Flannel) work?
        *   How do **Services** (ClusterIP, NodePort, LoadBalancer) work? Understand `kube-proxy`'s role (iptables/IPVS).
        *   **Ingress Controllers** (Nginx, Traefik) vs. API Gateways.
        *   **Service Mesh** (Istio/Linkerd): Understand the sidecar pattern (Envoy), mTLS, traffic splitting (canary deployments), and observability benefits. You don't need to set up a full mesh, but you must be able to explain its value.
    *   **Security:** SecurityContexts, PodSecurityPolicies/PodSecurityStandards, NetworkPolicies, RBAC (Role-Based Access Control), Service Accounts.
    *   **State:** PersistentVolumes (PV), PersistentVolumeClaims (PVC), StorageClasses. Know the difference between `ReadWriteOnce` and `ReadWriteMany`.

*   **Linux (Advanced):**
    *   **Debugging:** `strace`, `ltrace`, `/proc` filesystem, `lsof`, `netstat`/`ss`, `tcpdump`.
    *   **Performance:** `top`, `htop`, `iostat`, `vmstat`, `pidstat`. Understand CPU steal, I/O wait, and memory pressure.
    *   **OS Concepts:** Process lifecycle, signals, user vs. kernel space, systemd, cgroups (the foundation of containers).

*   **Networks:**
    *   **OSI Model:** Don't just list the layers. Be able to trace an HTTP request through them.
    *   **Linux Network Stack:** Routing tables, `iptables`/`nftables` (crucial for K8s), network namespaces.
    *   **Key Protocols:** TCP/IP, UDP, DNS, HTTP/S. Understand TLS handshakes.

*   **Observability (The Three Pillars):**
    *   **Logging:** Know how to structure logs (JSON). Understand the flow: App -> File/Stdout -> FluentBit/Logstash -> Central Storage (Elasticsearch) -> UI (Kibana/Graylog).
    *   **Metrics:** Prometheus architecture (Pull model, Service Discovery). Key metrics: RED (Rate, Errors, Duration) and USE (Utilization, Saturation, Errors). Writing alerting rules (PromQL).
    *   **Tracing:** OpenTelemetry/Distributed Tracing concepts (spans, traces).
    *   **SLA/SLI/SLO:** Be prepared to define these and discuss how you'd measure them.

#### 2. Hands-On Practice (The Practical Part)

This is the most critical part of your preparation.

*   **Python Automation:**
    *   Write a script that automates a tedious task. Example: A script that connects to a Kubernetes cluster using the `python-kubernetes` client, lists all pods in a namespace that are not in a "Running" state, and sends a notification to a Slack webhook.
    *   Use the `requests` library to interact with REST APIs (e.g., GitHub API, Prometheus API).
    *   Practice file I/O, parsing JSON/YAML, and error handling.

*   **Docker:**
    *   Write a multi-stage Dockerfile for a Python/Go web application. Make it secure: use a non-root user, minimize the image size, and ensure it has no critical vulnerabilities (use `docker scan`).
    *   Understand Docker build cache layers.

*   **Kubernetes:**
    *   **Set up a local cluster.** Use `minikube`, `kind` (Kubernetes in Docker), or `k3d`. Do not just use Docker Desktop.
    *   **Deploy a multi-tier application:** Create manifests for a web app, a cache (Redis), and a database (PostgreSQL). Use ConfigMaps for configuration and Secrets for sensitive data (practice encoding with base64).
    *   **Configure a Service and Ingress** to expose the web app.
    *   **Set up a CI/CD Pipeline:** Use GitHub Actions or GitLab CI to:
        1.  Lint your code/Dockerfile.
        2.  Build a Docker image and push it to Docker Hub/GitHub Container Registry.
        3.  Deploy the new image to your local Kubernetes cluster using `kubectl set image` or a more advanced method like Kustomize or Helm. (You may need a tool like `act` to test GitHub Actions locally).

*   **Monitoring:**
    *   Install Prometheus and Grafana on your local cluster (helm charts are the easiest way:`helm install prometheus prometheus-community/kube-prometheus-stack`).
    *   Get the sample application metrics into Grafana.
    *   Write a simple PromQL query to calculate error rate.

#### 3. Focus on "Responsibilities" (The "Lead" Aspect)

The test will evaluate your leadership and strategic thinking.

*   **Infrastructure Access Control (RBAC):** Be prepared to design an RBAC scheme. "Create a role that allows a developer to only view logs and restart deployments in the `staging` namespace." Practice this with `kubectl`.
*   **Deployment Automation:** Think about the pros and cons of different methods: plain YAML, Kustomize, Helm. Be able to argue for a strategy.
*   **Monitoring Expansion:** "The current system only monitors CPU/Memory. What would you add and why?" Talk about application-level metrics (RED) and business metrics.
*   **Infrastructure Audits:** How would you check for security best practices? (e.g., non-root users, up-to-date images, network policies). Tools like `kube-bench` or `kube-hunter` are good to mention.
*   **Incident Management:** Be ready to walk through your process. Use the **STAR method** (Situation, Task, Action, Result) to structure your answer for any scenario-based questions.
    *   *Example:* "Describe a time you dealt with a production outage."
    *   *Answer:* "(Situation) Our API latency spiked at 2 AM. (Task) My task was to lead the investigation and restore service. (Action) I first checked the monitoring dashboard to confirm the scope... I looked for recent deployments... I examined application logs and saw an increase in database connection timeouts... I scaled the database connection pool and restarted the affected pods... (Result) We restored service within 15 minutes and later implemented a permanent fix by optimizing the database query."

---

### During the 4-Hour Test: Your Game Plan

1.  **Read All Instructions Carefully (First 15 mins):** Before you write a single line of code, read the entire problem set. Understand all requirements. Prioritize tasks. Identify the "quick wins" and the more complex, time-consuming problems.
2.  **Plan and Outline (15 mins):** For a design question, sketch a diagram on paper or in a text editor. For a coding task, write pseudocode. This saves time and prevents costly refactoring later.
3.  **Time Management is Key:** Allocate time for each task. Leave a **minimum of 30 minutes at the end** for testing, documentation, and a final review. If you're stuck on something, make a note of your thought process and move on. A partially completed task is better than an entirely missed one.
4.  **Comment Your Code:** Explain your thinking. For a lead role, communication is vital. Comments show you can write maintainable code and document your work.
5.  **Version Control:** Even if it's not required, use `git`. Make small, atomic commits with clear messages (`git commit -m "fix: add liveness probe to web deployment"`). This shows professional practice.
6.  **Document Your Solutions:** Create a `README.md` file. For any configuration or code, explain:
    *   What it does.
    *   How to run it.
    *   Any assumptions you made.
    *   If you didn't have time to complete something, write what your next steps would be.

### Sample Task You Might Encounter

**"Design and implement a simple canary release pipeline for a web application on Kubernetes using GitHub Actions."**

*   **What they want to see:**
    *   A well-structured Dockerfile.
    *   K8s manifests for two deployments (`app-v1`, `app-v2`) and a service.
    *   A GitHub Actions workflow that:
        1.  Builds and tests on PR.
        2.  On push to `main`, builds a new image and deploys `v2` to 10% of traffic (using a service mesh or simple label switching with two services).
    *   How you handle secrets (Docker registry credentials, K8s kubeconfig).
    *   Documentation on how it works.

### Final Checklist Before the Test

*   [ ] Have a working Kubernetes environment (`minikube`/`kind`).
*   [ ] Ensure your IDE (VSCode, PyCharm) is set up with necessary extensions (YAML, Docker, Kubernetes).
*   [ ] Have the `kubectl`, `docker`, `python3`, and `git` commands ready and working.
*   [ ] Get a good night's sleep. A 4-hour test is a marathon, not a sprint.

Good luck! Your focus should be on demonstrating **advanced troubleshooting skills, secure and efficient design patterns, and clean, automated processes**.


## Core concepts expanded:

Of course. This is an excellent and detailed request. Let's break down these core concepts with clear, practical explanations.

### 1. Kubernetes Architecture: What Each Component Does

Think of Kubernetes as the operating system for your data center. It's a distributed system with a control plane (the brain) and worker nodes (the brawn).

#### The Control Plane (The Brain)

This manages the entire cluster. It's usually hosted on dedicated master nodes.

*   **kube-apiserver:** **The Front Door / The Only Communication Hub**
    *   **What it does:** This is the ONLY component that anything talks to. The CLI (`kubectl`), the UI, other control plane components, and all worker nodes all communicate *only* with the API Server. It exposes the REST API that you use to create, update, and delete objects (Pods, Deployments, Services, etc.).
    *   **Analogy:** The reception desk at a large company. Every request, whether from an employee or an outside visitor, goes through reception.

*   **etcd:** **The Source of Truth / The Cluster's Brain's Memory**
    *   **What it does:** A consistent and highly-available key-value store. It stores *all* cluster data: configuration, state, and secrets. Every change (e.g., `kubectl apply`) is written to etcd. The current state of every Pod, Node, and Service is stored here.
    *   **Analogy:** The company's central filing system or database. It's the single source of truth for everything that is happening and has happened.

*   **kube-scheduler:** **The Matchmaker / The Resource Allocator**
    *   **What it does:** It watches for newly created Pods that have no node assigned. For every Pod, the scheduler finds the *best* node to run it on based on factors like: resource requirements (CPU/RAM), hardware constraints, affinity/anti-affinity rules, and tolerations for node taints.
    *   **Analogy:** A hospital admissions coordinator who assigns a patient to a room based on the patient's needs (ICU, maternity) and the room's availability and equipment.

*   **kube-controller-manager:** ** The System That Makes Desired State Happen**
    *   **What it does:** It runs controller processes that continuously watch the state of the cluster (via the API Server) and make changes to drive the current state towards the desired state.
    *   **Key Controllers:**
        *   **Node Controller:** notices when nodes go down and responds.
        *   **Replication Controller:** ensures the correct number of Pods for a ReplicaSet are running.
        *   **Endpoint Controller:** populates the Endpoints object (links Services to Pods).
        *   **Service Account & Token Controllers:** create default accounts and API access tokens for namespaces.
    *   **Analogy:** An automated factory floor manager. If the order (desired state) says "10 widgets," the manager ensures 10 widgets are always being made, restarting machines if they break.

*   **cloud-controller-manager:** **The Cloud-Specific Link**
    *   **What it does:** Lets you link your cluster into your cloud provider's API (AWS, GCP, Azure). It separates the logic for interacting with cloud services (like creating a load balancer when you request a Service of type `LoadBalancer`).
    *   **Analogy:** A specialized translator who handles all communication with a specific foreign business partner.

#### The Worker Nodes (The Brawn)

These are the machines where your containers actually run.

*   **kubelet:** **The Node Agent / The Foreman on the Ground**
    *   **What it does:** An agent that runs on each node. It ensures that containers are running in a Pod. It takes a set of PodSpecs (YAML definitions) provided to it (usually from the API Server) and ensures the containers described in those PodSpecs are running and healthy.
    *   **Crucially,** it does *not* manage containers that were not created by Kubernetes.
    *   **Analogy:** The foreman on a construction site. The foreman takes instructions from the main office (API Server) and makes sure the specific workers (containers) on his site are doing their jobs correctly.

*   **kube-proxy:** **The Network Magician**
    *   **What it does:** Maintains network rules on nodes. These rules allow network communication to your Pods from inside or outside the cluster. It is responsible for the abstract concept of a "Service" (a stable IP address and DNS name) actually working by directing traffic to the right Pods, even as they move around.
    *   **Analogy:** The switchboard operator or a network router in an office, making sure calls and data packets get to the right extension (Pod).

*   **Container Runtime:** **The Engine that Runs Containers**
    *   **What it does:** The software that is responsible for running containers. Kubernetes supports several runtimes through the Container Runtime Interface (CRI). Examples: containerd, CRI-O.
    *   **Analogy:** The engine in a car. Kubernetes is the driver and dashboard, but the runtime is what actually makes the car move.

---

### 2. Linux Commands & OS Concepts

#### Linux Commands (The Advanced Debugging Toolkit)

*   **`strace`:** **Traces system calls.** It shows you every interaction a process has with the Linux kernel (reading files, making network requests, allocating memory). **Use case:** "Why is this process hanging?" `strace` can show you it's stuck on a specific system call.
*   **`ltrace`:** **Traces library calls.** Similar to `strace` but for calls to shared libraries (like `libc`). **Use case:** Debugging issues within an application's logic itself.
*   **`/proc` filesystem:** **A window into kernel and process data.** It's a virtual filesystem where files represent system and process information. For example, `/proc/cpuinfo` shows CPU details, and `/proc/<PID>/environ` shows the environment variables for a process. **Use case:** Inspecting the exact environment a process is running in.
*   **`lsof`:** **Lists open files.** In Linux, everything is a file (sockets, network connections, pipes, actual files). This command shows you every file a process has open. **Use case:** "Why can't I unmount this disk?" `lsof` will show you which process is holding a file open on it.
*   **`netstat` / `ss`:** **Network statistics.** `ss` is the modern replacement for `netstat`. They show socket statistics - listening ports, established connections, etc. **Use case:** "Is my application actually listening on port 8080?" `ss -tlnp | grep 8080`
*   **`tcpdump`:** **Network packet analyzer.** It captures raw network traffic on an interface. **Use case:** Debugging complex network issues. "Is the TLS handshake completing? Is the TCP connection even being established?"
*   **`top` / `htop` / `iostat` / `vmstat` / `pidstat`:** **Performance monitoring suite.**
    *   `top`/`htop`: Real-time view of process CPU and memory usage.
    *   `iostat`: Reports CPU statistics and device/partition I/O statistics. **Use case:** Identifying disk I/O bottlenecks.
    *   `vmstat`: Reports information about processes, memory, paging, block IO, traps, and CPU activity. **Use case:** Seeing if the system is under memory pressure (high swap usage).
    *   `pidstat`: Reports statistics for Linux tasks (processes). Great for drilling down into a specific process's resource usage over time.

#### OS Concepts (The Foundation of Containers)

*   **cgroups (Control Groups):** **Resource limiting and isolation.**
    *   **What it is:** A kernel feature that limits, accounts for, and isolates the resource usage (CPU, memory, disk I/O, network) of a collection of processes.
    *   **Why it matters:** This is how Docker and Kubernetes enforce resource `limits` and `requests` on a container. It's what stops one container from hogging all the RAM on a machine.

*   **Namespaces:** **Isolation of global system resources.**
    *   **What it is:** A kernel feature that wraps a set of system resources and presents them to a process so it looks like they have their own isolated instance of those resources.
    *   **Types:** PID (process IDs), Network (network interfaces, routing tables), Mount (filesystem mount points), UTS (hostname), IPC (inter-process communication), User (user IDs).
    *   **Why it matters:** This is how containers get their own isolated view of the system. A process in a container has its own PID 1, its own network interfaces, and its own filesystem. **Containers are essentially processes running on a Linux host with cgroups and namespaces applied.**

---

### 3. SLA, SLI, SLO: The Hierarchy of Reliability

This is a framework for measuring and defining the reliability of your service. It's a core concept of Site Reliability Engineering (SRE).

*   **SLI (Service Level Indicator):** **The Measurement - *What* you measure.**
    *   **Definition:** A carefully defined quantitative measure of some aspect of the level of service that is provided.
    *   **Examples:**
        *   **Availability:** Uptime (e.g., % of successful requests)
        *   **Latency:** How fast your service is (e.g., 99th percentile request duration < 200ms)
        *   **Throughput:** How much work it does (e.g., requests per second)
        *   **Error Rate:** The proportion of requests that fail (e.g., HTTP 5xx errors)

*   **SLO (Service Level Objective):** **The Goal - *The target value* for your SLI.**
    *   **Definition:** A target value or range of values for a service level that is measured by an SLI. It's an internal goal.
    *   **Examples:**
        *   "Availability SLI **must be** 99.9% over a 30-day rolling period."
        *   "Latency SLI for the `/api` endpoint **must be** < 100ms for the 90th percentile."
    *   **Why it matters:** SLOs are the core of data-driven decisions. They define when your service is "reliable enough." If you're consistently missing your SLO, you should stop feature work and focus on reliability.

*   **SLA (Service Level Agreement):** **The Contract - *The promise* to your users.**
    *   **Definition:** An explicit or implicit contract with your users that includes consequences (usually financial, like a service credit) if the SLOs are not met.
    *   **Key Difference:** An SLO is an **internal goal**. An SLA is an **external promise**. You *must* set your internal SLOs stricter than your SLA to give yourself a safety buffer.
    *   **Example:** "We promise our users (SLA) 99.9% uptime, but our internal team's goal (SLO) is 99.95%."

| Concept | Role | Question it Answers | Example |
| :--- | :--- | :--- | :--- |
| **SLI** | **Measurement** | *What* should we measure? | The proportion of successful HTTP requests. |
| **SLO** | **Target** | *What* is the goal for that measurement? | The SLI must be >= 99.9% over 30 days. |
| **SLA** | **Contract** | What happens if we **miss** the goal? | If uptime < 99.9%, customers get a 10% service credit. |

For your interview, you could say: "To expand the monitoring system, I would first work with the product team to define SLOs based on user-centric SLIs like latency and error rate for key features. Then, I'd ensure Prometheus is capturing those metrics and set up alerts to fire *before* we breach those SLOs, not just when the service is fully down." This shows strategic thinking.

### 4. Securing Kubernetes

#### Kube-bench (Needs improvement)
Kube-bench is an open-source tool developed by Aqua Security designed to check whether a Kubernetes cluster is deployed securely. It achieves this by running checks against the recommendations outlined in the CIS Kubernetes Benchmark, a security standard published by the Center for Internet Security. 
Key features and functionalities of Kube-bench:
CIS Kubernetes Benchmark Compliance:
Kube-bench automates the process of verifying a Kubernetes cluster's configuration against the best practices and controls defined in the CIS Kubernetes Benchmark.
Security Assessment:
It helps identify potential security vulnerabilities and misconfigurations in various areas of a Kubernetes deployment, including host configuration, worker node security, control plane security, and policy enforcement (e.g., RBAC, Pod Security Standards).
Automated Checks:
Kube-bench automates the security auditing process, reducing the manual effort required to ensure compliance and consistency across Kubernetes environments.
Report Generation:
It generates reports detailing the results of the security checks, indicating which configurations pass or fail the benchmark recommendations. These reports help users understand the security posture of their cluster and prioritize remediation efforts.
Ease of Use:
Kube-bench can be run as a Go application, a Docker container, or as a Kubernetes Job, offering flexibility in deployment and integration into existing CI/CD pipelines. Its configuration is managed through easy-to-update YAML files.
Extensibility:
Kube-bench supports benchmarks for various Kubernetes flavors, including those offered by public cloud providers like AWS EKS, Azure AKS, and Google GKE, as well as platforms like Rancher RKE2.
In essence, Kube-bench serves as a vital tool for hardening Kubernetes clusters, ensuring they adhere to established security best practices, and mitigating potential risks before they can be exploited.

#### Kube-hunter (Needs improvement)

Kube-hunter is an open-source penetration testing tool that simulates attacker behavior to find and report security vulnerabilities in Kubernetes clusters. It actively probes the cluster's attack surface, such as API servers and kubelets, to identify weaknesses like exposed services and misconfigurations. While useful for labs and controlled environments, it is now considered maintenance-stopped, and for modern scanning workflows, tools like Trivy are recommended instead.  

Key Features and How it Works
Simulates Attacks:
Kube-hunter functions like a real attacker, looking for ways to exploit vulnerabilities within the Kubernetes environment. 
Identifies Weaknesses:
It targets the entire Kubernetes attack surface, including the API server, kubelets, and other components. 
Active and Passive Modes:
Passive Mode: Simply observes and discovers vulnerabilities without exploiting them, making it safer for sensitive environments. 
Active Mode: Attempts to exploit found vulnerabilities to discover additional ones. 
Automated Scanning:
It automates the process of finding exploitable weaknesses, which is a critical step for DevSecOps teams to take before malicious actors discover them. 
Comprehensive Scanning:
It scans for a range of issues, including misconfigurations, exposed services, and vulnerable components. 
Considerations 
Maintenance-Stopped:
The project is no longer actively maintained, meaning it might not be updated for newer Kubernetes versions or threats.
Use Cases:
Kube-hunter is primarily recommended for educational purposes, lab exercises, or point-in-time testing in controlled environments.
Modern Alternatives:
For automated, modern security scanning workflows, tools like Trivy and the Trivy Operator are now the preferred choice.    

## CICD with Canary Release Pipeline with Kubernetes and GitHub Actions

I'll help you design and implement a simple canary release pipeline for a web application on Kubernetes using GitHub Actions. This is a comprehensive solution that covers all the key aspects mentioned in your job requirements.

## Architecture Overview

1. **Kubernetes Setup**: Deployments for stable and canary versions with a service to route traffic
2. **GitHub Actions Pipeline**: Automated build, test, and deployment workflow
3. **Traffic Management**: Using Kubernetes service with pod selection labels
4. **Monitoring**: Basic health checks to validate the canary deployment

## Implementation Steps

### 1. Kubernetes Manifests

First, let's create the Kubernetes deployment and service manifests:

**deployment.yaml**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-stable
  labels:
    app: webapp
    track: stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
      track: stable
      
```
**deployment-canary.yaml**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-canary
  labels:
    app: webapp
    track: canary
spec:
  replicas: 1  # Start with just one pod for canary
  selector:
    matchLabels:
      app: webapp
      track: canary
      ...
```      

**service.yaml**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp  # This selects both stable and canary pods
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
```
**ingress.yaml**:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: your-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-service
            port:
              number: 80
```

### 2. GitHub Actions Workflow

Create `.github/workflows/canary-deployment.yaml`:

```yaml
name: Canary Deployment Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
  K8S_NAMESPACE: production
  APP_NAME: webapp

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

    - name: Run tests
      run: |
        # Add your test commands here
        python -m pytest tests/ -v

  build-and-push:
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Log in to container registry
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Extract metadata for Docker
      id: meta
      uses: docker/metadata-action@v4
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=sha,prefix=,suffix=,format=long
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}

    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  deploy-canary:
    runs-on: ubuntu-latest
    needs: build-and-push
    environment: production
    permissions:
      contents: read
      deployments: write
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Configure Kubernetes
      uses: azure/setup-kubectl@v3
      with:
        version: 'v1.25.0' # Specify your kubectl version

    - name: Deploy canary
      run: |
        # Update the canary deployment with the new image
        kubectl set image deployment/webapp-canary webapp=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -n ${{ env.K8S_NAMESPACE }}
        
        # Wait for canary to be ready
        kubectl rollout status deployment/webapp-canary -n ${{ env.K8S_NAMESPACE }} --timeout=300s
        
        # Get the canary pod name
        CANARY_POD=$(kubectl get pods -n ${{ env.K8S_NAMESPACE }} -l track=canary -o jsonpath='{.items[0].metadata.name}')
        
        # Run basic health check against the canary pod
        kubectl exec $CANARY_POD -n ${{ env.K8S_NAMESPACE }} -- curl -s http://localhost:8080/health || exit 1
      env:
        KUBECONFIG: ${{ secrets.KUBECONFIG }}

    - name: Wait for canary stabilization
      run: |
        # Wait for some time to monitor canary performance
        sleep 300  # 5 minutes
        
        # Check canary pod logs for errors
        kubectl logs -n ${{ env.K8S_NAMESPACE }} -l track=canary --tail=50
      env:
        KUBECONFIG: ${{ secrets.KUBECONFIG }}

  promote-canary:
    runs-on: ubuntu-latest
    needs: deploy-canary
    environment: production
    # This step requires manual approval
    if: always() && needs.deploy-canary.result == 'success'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Configure Kubernetes
      uses: azure/setup-kubectl@v3
      with:
        version: 'v1.25.0'

    - name: Promote canary to stable
      run: |
        # Update stable deployment with the canary image
        kubectl set image deployment/webapp-stable webapp=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -n ${{ env.K8S_NAMESPACE }}
        
        # Scale up stable deployment
        kubectl scale deployment/webapp-stable --replicas=3 -n ${{ env.K8S_NAMESPACE }}
        
        # Scale down canary deployment
        kubectl scale deployment/webapp-canary --replicas=0 -n ${{ env.K8S_NAMESPACE }}
        
        # Wait for stable rollout to complete
        kubectl rollout status deployment/webapp-stable -n ${{ env.K8S_NAMESPACE }} --timeout=300s
      env:
        KUBECONFIG: ${{ secrets.KUBECONFIG }}

    - name: Update deployment status
      run: |
        # Notify success (you could integrate with Slack, Teams, etc.)
        echo "Deployment completed successfully for commit ${{ github.sha }}"
```



### 4. Setup Instructions

1. **Prepare your Kubernetes cluster** and ensure you have access via kubectl
2. **Create the necessary secrets in GitHub**:
    - `KUBECONFIG`: Your Kubernetes configuration file
    - Container registry credentials if using a private registry

3. **Apply the initial Kubernetes manifests**:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

4. **Configure GitHub Environments**:
    - Go to your repository Settings → Environments
    - Create a "production" environment
    - Configure deployment protection rules with required reviewers

5. **Update the workflow environment variables** to match your setup

### 5. Advanced Enhancements

For a production-ready system, consider adding:

1. **Service Mesh Integration** (Istio/Linkerd) for more precise traffic control
2. **Prometheus metrics validation** in the canary stage
3. **Automated rollback** on failure detection
4. **Integration with your monitoring system** (e.g., Prometheus alerts)
5. **Database migration handling** if your application requires schema changes

This implementation demonstrates your expertise in Kubernetes, Docker, CI/CD, Python automation, and shows an understanding 
of progressive delivery strategies - all key requirements for the DevOps Lead position.

# Improved Dockerfile and Configuration for Production

Dockerfile for production use needs to set up environment variables properly. 
Here's a better solution:

## Dockerfile

```dockerfile
# Use an official Python runtime as a base image with a specific version for reproducibility
FROM python:3.7-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_DEBUG=0
ENV FLASK_ENV=production

# Create a non-root user for security
RUN adduser --disabled-password --gecos '' appuser

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create .env file from build arguments (optional, see alternative approach below)
# ARG REGISTRY_URL
# ARG API_URL
# RUN echo "REGISTRY_URL=$REGISTRY_URL" >> .env && \
#     echo "API_URL=$API_URL" >> .env

# Change ownership of the application directory
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "3", "main:app"]
```

### Generate Dockerfile with a script
```bash
#!/bin/bash
cat > Dockerfile << EOF
FROM node:18-alpine
WORKDIR /app
RUN yarn install --production
EXPOSE 3000
CMD ["node", "src/index.js"]
EOF
cat Dockerfile
```

## Set environment Variables at Runtime

For production, it's generally better to pass environment variables at runtime rather than
baking them into the image. Here's how to modify your deployment to use this approach:

### 1. Update your deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

```

### 2. Update your configmap.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: flask-demo-config
  
data:
  flights_api_key: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiZTU5MzYxZWNhNDAzYWIyOTdmNzJkNGI4ODg5NDQ0ZjkxYzUxOGZmMmQyOTUwNjhmMjlkYTg3YzUwYzI3MmE3MjRiMzkyNDdjOGU2ZjM3ZjIiLCJpYXQiOjE2NzQ1MDk3NTksIm5iZiI6MTY3NDUwOTc1OSwiZXhwIjoxNzA2MDQ1NzU5LCJzdWIiOiIxOTc3OCIsInNjb3BlcyI6W119.qKWaN0ntSu9pX64Pm7HrxO8yP1ZAC5m3W5iGf8mfAzj3ltPZzWGJdOKGwZLXkGdHXtPDqMYLGSVyKXAK2h0baw'
  registry_url: 'https://your-registry-url.com'
  api_url: 'https://your-api-url.com'
```

### 3. Create a .env.example file

Create a `.env.example` file in your project root to document the required environment variables:

```bash
# Application settings
FLASK_DEBUG=0
FLASK_ENV=production

# API keys and URLs
FLIGHTS_API_KEY=your_api_key_here
REGISTRY_URL=https://your-registry-url.com
API_URL=https://your-api-url.com
```

### 4. Create a script to generate the ConfigMap

Create a script to generate your ConfigMap from a local .env file (for development purposes):

**generate-configmap.sh**
```bash
#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# Create or update the ConfigMap
kubectl create configmap flask-demo-config \
  --namespace=demo-services \
  --from-literal=registry_url=${REGISTRY_URL} \
  --from-literal=api_url=${API_URL} \
  -o yaml --dry-run=client | kubectl apply -f -
```

### 5. Create a .dockerignore file

To improve build performance and security, create a `.dockerignore` file:

```
.git
.env
*.pyc
__pycache__
Dockerfile
.dockerignore
README.md
.gitignore
```

## Key features

1. **Security**:
    - Using a non-root user
    - Not including sensitive information in the image
    - Using a .dockerignore file to exclude sensitive files

2. **Performance**:
    - Using Python slim image for smaller size
    - Separating dependency installation from code copying to leverage Docker cache

3. **Production Readiness**:
    - Using Gunicorn as a production WSGI server instead of the Flask development server
    - Setting proper Python environment variables
    - All configuration passed at runtime via ConfigMap

4. **Maintainability**:
    - Clear documentation of environment variables
    - Script to generate ConfigMap from .env file

To use this setup:
1. Create a `.env` file from the `.env.example` template with your actual values
2. Run the `generate-configmap.sh` script to create the ConfigMap in your cluster
3. Build your Docker image: `docker build -t your-image-name .`
4. Deploy using your updated deployment.yaml


**Best practice**
This approach follows Kubernetes best practices by keeping configuration separate from 
application code and allowing you to change configuration without rebuilding your container image.


https://coderbyte.com/candidate-assessment
Describe how you would implement a continuous deployment pipeline for a web application in a Linux environment.

1. Version Control System (VCS):
   Host your web application's source code in a VCS like Git (e.g., GitHub, GitLab, Bitbucket). This serves as the single source of truth for your code.
2. Continuous Integration (CI) Server:
   Use a CI server (e.g., Jenkins, GitLab CI/CD, GitHub Actions) to automate the build and test process.
   Configure the CI server to trigger a pipeline whenever changes are pushed to the VCS.
   Build Stage: Compile your application, resolve dependencies, and create deployable artifacts (e.g., WAR, JAR, Docker image).
   Test Stage: Run automated unit, integration, and end-to-end tests to ensure code quality and functionality.
3. Artifact Repository:
   Store your deployable artifacts in a centralized repository (e.g., Nexus, Artifactory, Docker Hub for Docker images). This ensures versioning and easy retrieval during deployment.
4. Deployment Environment (Linux Servers, Kubernetes, Lambda functions, Elasticbeanstalk)
   Prepare your servers (e.g., EC2 instances, VMs) where the application will be deployed.
   Ensure necessary software and dependencies (e.g., web server like Nginx/Apache, application server like Tomcat/JBoss, database) are installed and configured.
5. Deployment Tool:
   Utilize a deployment tool (e.g., Ansible, Chef, Puppet, AWS CodeDeploy, Capistrano) to automate the deployment process to your Linux servers.
   Deployment Script/Configuration: Define the steps required to deploy your application, including:
   Retrieving the artifact from the repository.
   Stopping the existing application instance.
   Copying the new artifact to the deployment target.
   Configuring the application (e.g., environment variables, database connections).
   Starting the new application instance.
   Performing post-deployment health checks.
6. Pipeline Orchestration:
   Integrate the CI and CD stages into a cohesive pipeline using your CI server or a dedicated CD tool like AWS Codebuild or Github Actions
   Define stages like "Build," "Test," "Deploy to Staging" "Deploy to Production."
   Implement approval gates for critical stages (e.g., before deploying to production).

7. Monitoring and Rollback:
   Implement monitoring tools (e.g., Prometheus, Grafana, Opensearch) to track application performance and health after deployment.
   Establish a clear rollback strategy in case of deployment failures or issues in production.
   Git: Code hosted on GitHub.
   

8. Github Actions:
   Actions pipeline is triggered on every git push.
   Build: Build the application and produce artifacts (WAR file, Docker Image)
   Test: Run Unit tests and integrations tests.
   Artifact Archiving: Archive build artifacts
   Deploy to Staging: Deploy after testing and use Kubernetes rollout approach.
   Deploy to Production: (Manual approval).
   Monitoring: Zabbix monitor the health of the deployed application, Openserach and Fluent-bit for logging.