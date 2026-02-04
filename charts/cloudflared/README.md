# Cloudflared

A tunneling daemon that proxies traffic from the Cloudflare network to your origins. This daemon sits between Cloudflare network and your origin (e.g. a webserver). Cloudflare attracts client requests and sends them to you via this daemon, without requiring you to poke holes on your firewall --- your origin can remain as closed as possible. Extensive documentation can be found in the [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps) section of the Cloudflare Docs.

## TL;DR

```console
helm repo add duck-helm https://ducksify.github.io/duck-helm
helm install cloudflared duck-helm/cloudflared
```

## Introduction

Cloudflare Tunnel provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address. With Tunnel, you do not send traffic to an external IP — instead, a lightweight daemon in your infrastructure (cloudflared) creates outbound-only connections to Cloudflare’s edge. This chart runs **cloudflared** in one of two modes: **Tunnel mode** (default) — Argo Tunnel; **Access mode** — `cloudflared access ssh` or `cloudflared access tcp` behind Cloudflare Access with a service token.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.2.0+
- **Tunnel mode**: Argo Tunnel token (from Cloudflare Zero Trust dashboard).
- **Access mode**: Access application hostname and a [service token](https://developers.cloudflare.com/cloudflare-one/access-controls/service-credentials/service-tokens/) (Zero Trust > Access > Service Auth).

## Installing the Chart

To install the chart with the release name `cloudflared`:

```console
helm install cloudflared duck-helm/cloudflared
```

The command deploys cloudflared on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `cloudflared` deployment:

```console
helm delete cloudflared
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Image parameters

| Name                    | Description                                   | Value                    |
|-------------------------|-----------------------------------------------|--------------------------|
| `image.repository`      | The Docker repository to pull the image from. | `cloudflare/cloudflared` |
| `image.imagePullPolicy` | The logic of image pulling.                   | `IfNotPresent`           |

### Deployment parameters

| Name                               | Description                                                                 | Value    |
|------------------------------------|-----------------------------------------------------------------------------|----------|
| `mode`                             | Run mode: `tunnel` or `access`                                             | `tunnel` |
| `replicaCount`                     | Number of replicas                                                         | `2`      |
| `auth.tunnelToken`                 | Argo tunnel JWT token (tunnel mode only)                                   | `""`     |
| `auth.accessServiceTokenId`        | Access service token ID (access mode only)                                | `""`     |
| `auth.accessServiceTokenSecret`     | Access service token secret (access mode only)                             | `""`     |
| `existingSecret`                   | Use existing secret: tunnel key `token`; access keys `serviceTokenId`, `serviceTokenSecret` | `""` |
| `access.type`                      | Access subcommand: `ssh` or `tcp` (access mode only)                       | `ssh`    |
| `access.hostname`                  | Access application hostname (e.g. `hostname.example.com`)                  | `""`     |
| `access.url`                       | Local listen address to proxy (e.g. `0.0.0.0:2222` or `0.0.0.0:8080`)      | `""`     |
| `nodeSelector`                     | Node selector for pod placement                                            | `{}`     |

Specify parameters with `--set key=value` or use a custom values file:

```console
helm install cloudflared duck-helm/cloudflared -f my-values.yaml
```

See [values.yaml](values.yaml) for the full default configuration.

## Configuration

### Tunnel mode (default)

Create a tunnel in the Cloudflare Zero Trust dashboard, then install with the tunnel token:

```console
helm install cloudflared duck-helm/cloudflared --set auth.tunnelToken=eyJ...
```

### Access mode (SSH or TCP)

Expose SSH or TCP behind Cloudflare Access using a [service token](https://developers.cloudflare.com/cloudflare-one/access-controls/service-credentials/service-tokens/). The chart runs `cloudflared access ssh` or `cloudflared access tcp` with your hostname, URL, and token.

**SSH** (e.g. `cloudflared access ssh --hostname ssh.example.com --url 0.0.0.0:2222`):

```console
helm install cloudflared duck-helm/cloudflared \
  --set mode=access \
  --set access.type=ssh \
  --set access.hostname=ssh.example.com \
  --set access.url=0.0.0.0:2222 \
  --set auth.accessServiceTokenId=yyyy.access \
  --set auth.accessServiceTokenSecret=xxxxx
```

**TCP** (generic TCP proxy):

```console
helm install cloudflared duck-helm/cloudflared \
  --set mode=access \
  --set access.type=tcp \
  --set access.hostname=tcp.example.com \
  --set access.url=0.0.0.0:8080 \
  --set auth.accessServiceTokenId=yyyy.access \
  --set auth.accessServiceTokenSecret=xxxxx
```

For production, store credentials in a Secret with keys `serviceTokenId` and `serviceTokenSecret`, then set `existingSecret` to that secret name instead of passing token values on the command line.

## License

Copyright &copy; 2023 Ducksify

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
