# Devops Study guide

##  Test Format (Coderbyte)

A 4-hour test on Coderbyte for a lead position will almost certainly be a **project-based assessment**, not just a series of multiple-choice questions. You will likely be given a scenario or a set of tasks to complete within the time limit. This could involve:

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
    *   Install Prometheus and Grafana on your local cluster (helm charts are the easiest way: `helm install prometheus prometheus-community/kube-prometheus-stack`).
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