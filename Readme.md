# Infrastructure as Code
## Overview

This repository contains Terraform configurations for provisioning and managing core cloud infrastructure following industry best practices. The infrastructure is organized in a layered approach, ensuring separation of concerns, environment isolation, and maintainability.

## Architecture Philosophy

We follow a **layer-based separation** pattern:

| Layer                                                                                                       | Team Responsible  | Key Components | Description |
|-------------------------------------------------------------------------------------------------------------|-------------------|----------------|-------------|
| [**Core Layer**](https://github.com/andresr27/devops_kubernetes_sample/tree/main/core)                      | Cloud Engineers   | VPC, Security Groups, IAM, DNS | Foundational network and security infrastructure |
| [**Middleware Layer**](https://github.com/andresr27/devops_kubernetes_sample/tree/latest_branch/middleware) | DevOps Engineers  | Kubernetes, Databases, Caching, Messaging | Shared services and platform components |
| [**Application Layer** ](https://github.com/andresr27/flask-demo-service/tree/main)                         | Application Teams | Containerized Apps, Load Balancers, CI/CD | Environment-specific application infrastructure |

This separation allows different teams to work concurrently while maintaining clear boundaries and ownership.


**Development Approach**:
- All services run within Minikube cluster
- Self-managed deployments for development flexibility
- Focus on rapid iteration and testing

### Production Environment (Managed Services)
Our production environment leverages managed services for reliability:

```
core/
├── environments/         # Environment-specific configurations
│   ├── prod/             # Production environment
│   ├── stage/            # Staging environment
│   └── dev/              # Development environment
├── modules/              # Reusable Terraform modules
│   ├── vpc/              # VPC and networking components
│   ├── eks/              # Kubernetes cluster resources
│   ├── rds/              # Database resources
│   ├── security/         # Security groups and IAM
│   └── monitoring/       # Monitoring and alerting
├── scripts/              # Helper scripts and utilities
├── docs/                 # Architecture and documentation
└── examples/             # Example implementations
middleware/
└── prod/
    ├── kubernetes/
    │   ├── fluent-bit/          # Log forwarding to OpenSearch
    │   ├── prometheus/          # Metrics collection
    │   └── synthetic-checker/   # Synthetic monitoring
    ├── opensearch/              # Managed logging and search
    └── zabbix/                  # Enterprise monitoring solution
```

**Production Approach**:
- Managed database services (RDS, etc.)
- Zabbix for comprehensive metrics and alerting
- OpenSearch managed service for logging
- Enterprise-grade reliability and support

## Environment Strategy

We maintain three distinct environments:

1. **Development**: For active development and testing (Minikube-based)
2. **Staging**: For pre-production validation and testing
3. **Production**: For live customer traffic (Managed services)

Each environment has its own configuration while sharing common foundational patterns.
