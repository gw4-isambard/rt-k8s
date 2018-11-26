# rt-k8s - Request Tracker in Kubernetes

## Deploy in Azure

In the portal https://portal.azure.com/ create a new Resource Group called
``IsambardServiceDeskResourceGroup``

run

```bash
az login
az aks create \
    --resource-group IsambardServiceDeskResourceGroup \
    --name IsambardServiceDesk
az aks get-credentials \
    --resource-group IsambardServiceDeskResourceGroup \
    --name IsambardServiceDesk 
kubectl cluster-info
```

## Deploy in Oracle Compute Infrastructure

```bash

```
