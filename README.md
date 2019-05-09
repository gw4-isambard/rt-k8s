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

Use the web interface, Dashboard -> Developer Services -> Container Clusters
(OKE). Click on Create Cluster, fill in the form with a name, choose Kebernetes
v1.11.5, choose Quick Create, a shape of `VM.Standard2.1` is sufficeint, use
one per subnet)

After the cluster is created, in the cluster main page click on "Access Kubeconfig". Follow the instructions.

One this is done you should be able to use kubectl to manage the cluster

```
kubectl cluster-info
```

## Kubernetes 
