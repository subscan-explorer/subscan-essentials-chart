
# Subscan Essentials Helm Chart

This Helm chart deploys the Subscan Essentials stack, including API, Worker, Daemon, and UI components. It supports multi-network (mainnet/testnet) configuration and is compatible with both Traefik and Ingress-Nginx.

---

## Dependencies

Before installing this chart, you must have the following dependencies available in your Kubernetes cluster or accessible network environment:

- **Ingress Controller**
  - If `ingress.type=ingress-nginx`, install [ingress-nginx](https://github.com/kubernetes/ingress-nginx).
  - If `ingress.type=traefik`, install [Traefik](https://github.com/traefik/traefik).
- **Database and Cache Services**
  - **PostgreSQL**: Required for backend data storage. Configure connection details using `DB_DRIVER=postgres`, `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_DB`, and `POSTGRES_PASSWORD` in the appropriate environment variable section of your `values.yaml` (e.g., `mainnetEnvVars`, `testnetEnvVars`, or per-network `envVars`).
  - **Redis**: Required for caching. Configure connection details using `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`, and `REDIS_DATABASE` in the same environment variable sections.

Refer to the official documentation for installation instructions for each controller and database/cache system. Make sure all connection information is set in `values.yaml` under the appropriate environment variable sections before deploying this chart.

---

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Upgrading](#upgrading)
- [Configuration](#configuration)
- [Templates Overview](#templates-overview)
- [Examples](#examples)
- [Advanced Usage](#advanced-usage)
- [References](#references)

---

## Introduction

This chart provides a flexible way to deploy Subscan Essentials services. You can customize images, resources, environment variables, ingress domains, and more via `values.yaml`. Both mainnet and testnet networks are supported.

---

## Installation

```sh
helm repo add subscan https://subscan-explorer.github.io/subscan-essentials-chart/
helm install subscan-essentials subscan/subscan-essentials-chart -f example/subscan-essentials/values.yaml
```

## Upgrading

```sh
helm upgrade subscan-essentials subscan/subscan-essentials-chart -f example/subscan-essentials/values.yaml
```

---

## Configuration

The following table lists the most important configurable parameters of the chart and their default values. For a full list, see `values.yaml`.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `commonLabels` | Common Kubernetes labels for all resources | See values.yaml |
| `mainnetEnvVars` | Mainnet environment variables | See values.yaml |
| `testnetEnvVars` | Testnet environment variables | See values.yaml |
| `networkTemplate` | Default configuration template for each component | See values.yaml |
| `testnet` | Testnet network-specific configuration | `{}` |
| `mainnet` | Mainnet network-specific configuration | `{}` |
| `images.backend.repository` | Backend image repository | quay.io/subscan-explorer/subscan-essentials |
| `images.backend.mainnet` | Backend image tag for mainnet | sha-5775183-33 |
| `images.backend.testnet` | Backend image tag for testnet | sha-5775183-33 |
| `images.ui.repository` | UI image repository | quay.io/subscan-explorer/subscan-essentials-ui |
| `images.ui.tag` | UI image tag | sha-54e17a7-13 |
| `ingress.type` | Ingress type (`traefik` or `ingress-nginx`) | traefik |
| `ingress.mainDomain` | Main domain for ingress | subscan.io |

### Component Parameters (from `networkTemplate`)

- `daemon.enabled`: Enable Daemon component
- `worker.replicaCount`: Number of Worker replicas
- `api.autoscaling.enabled`: Enable autoscaling for API
- `ui.enabled`: Enable UI component
- `resources.requests/limits`: Resource requests and limits
- `envVars`: Custom environment variables
- `image.tag`: Image tag override

### Network Configuration

- `testnet.<network>.values`: Per-testnet network configuration (env vars, worker replicas, ingress subdomains, etc.)
- `mainnet`: Mainnet configuration (same structure as above)

---

## Templates Overview

This chart includes the following Kubernetes resources:

- `deployment-api.yaml`: API Deployment
- `deployment-worker.yaml`: Worker Deployment
- `deployment-daemon.yaml`: Daemon Deployment
- `deployment-ui.yaml`: UI Deployment
- `service.yaml`: Service definitions for all components
- `ingressroute-api.yaml`, `ingressroute-ui.yaml`: Traefik IngressRoute resources
- `configmap-ui.yaml`: UI ConfigMap
- `secret-envvars-backend.yaml`: Backend environment variable Secret

---

## Examples

### 1. Enable the assethub-westend testnet

```yaml
testnet:
    assethub-westend: # It must be equal NETWORK_NODE
        values:
            envVars:
                CHAIN_WS_ENDPOINT: wss://api-asset-hub-westend.dwellir.com/xxxxxxxx
                NETWORK_NODE: assethub-westend # It must be equal to and unique from the network name.
                POSTGRES_DB: subscan_assethub_westend
                POSTGRES_HOST: subscan-postgres-testnet-a
                ETH_RPC: https://westend-asset-hub-eth-rpc.polkadot.io
                REDIS_HOST: subscan-redis-essentials-master.db.svc
            worker:
                replicaCount: 1
                image:
                    tag: "your-custom-tag"
            api:
                image:
                    tag: "your-custom-tag"
            daemon:
                image:
                    tag: "your-custom-tag"
            ui:
                image:
                    tag: "your-custom-tag"
            ingress:
                subdomains:
                    - assethub-westend-lite
                    - assethub-westend-essentials

```

### 2. Override image tags

```yaml
images:
  backend:
    repository: "quay.io/subscan-explorer/subscan-essentials"
    mainnet: "sha-5775183-33"
    testnet: "sha-5775183-33"
  ui:
    repository: "quay.io/subscan-explorer/subscan-essentials-ui"
    tag: "sha-54e17a7-13"
```

---

## Advanced Usage

- Supports referencing secrets via `envFrom`
- Custom resource limits and pod security context
- Multi-network, multi-instance deployments

---

## References

- [Helm Documentation](https://helm.sh/docs/)
- [Subscan Essentials Backend](https://github.com/subscan-explorer/subscan-essentials)
- [Subscan Essentials UI](https://github.com/subscan-explorer/subscan-essentials-ui-react)

---