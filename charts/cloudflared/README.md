# Cloudflared

A tunneling daemon that proxies traffic from the Cloudflare network to your origins. This daemon sits between Cloudflare network and your origin (e.g. a webserver). Cloudflare attracts client requests and sends them to you via this daemon, without requiring you to poke holes on your firewall --- your origin can remain as closed as possible. Extensive documentation can be found in the [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps) section of the Cloudflare Docs.

## TL;DR

```console
helm repo add duck-helm https://ducksify.github.io/duck-helm
helm install cloudflared duck-helm/cloudflared
```

## Introduction

Cloudflare Tunnel provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address. With Tunnel, you do not send traffic to an external IP — instead, a lightweight daemon in your infrastructure (cloudflared) creates outbound-only connections to Cloudflare’s edge. Cloudflare Tunnel can connect HTTP web servers, SSH servers, remote desktops, and other protocols safely to Cloudflare. This way, your origins can serve traffic through Cloudflare without being vulnerable to attacks that bypass Cloudflare.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.2.0+
- Argo Tunnel ID generated

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

| Name                | Description                                                                  | Value   |
|---------------------|------------------------------------------------------------------------------| ------- |
| `replicaCount`      | The number of replicas to deploy.                                            | `3`     |
| `auth.tunnelToken`  | The Argo tunnel jwt token.                                                   | `""`    |
| `existingSecret`    | The name of an existing secret containing the Argo tunnel settings.          | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install example \
  --set user=example \
  --set password=example \
    kubitodev/example
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install example -f values.yaml duck-helm/example
```

> **Note**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Cloudflared the managed way
If you choose to install cloudflared by managed way, no configuration is necessary

Create tunnel from UI, then provide jwt token during helm installation
```console
helm install cloudflared --set auth.tunnelToken=ey.....
```

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
