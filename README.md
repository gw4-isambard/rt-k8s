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

Get the `kubectl` credential file

```
oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.iad.aaaaaaaaae4dqzrrhbrtkzlfha3genbxgjqwmmtdmm3tomzsmc2tsojsmy2w --file $HOME/.kube/config --region us-ashburn-
```

You can then see the cluster with

```
kubectl cluster-info
```

## Kubernetes

Create a namespace:

    kubectl create namespace rt

Initialise/update helm:

    helm init --upgrade

Set up NGINX ingress:

    helm install --namespace=rt stable/nginx-ingress

    # Get external IP address (may take a few minutes)
    kubectl get service --namespace=rt

Start the service:

    kubectl create --namespace=rt -f rt-svc.yaml
    kubectl apply --namespace=rt -f rt-ingress.yaml

Create the PVC:

    kubectl create  --namespace=rt -f rt-pvc.yaml

Create Kubernetes secrets:

    kubectl create secret generic --namespace=rt mail-user --from-file=username=./mail-user.txt
    kubectl create secret generic --namespace=rt mail-pass --from-file=password=./mail-pass.txt
    kubectl create secret generic --namespace=rt db-pass --from-file=password=./db-pass.txt

Start the deployment:

    kubectl create --namespace=rt -f rt-pod.yaml

Initialise the RT database:

    # Get name of pod
    POD=$(kubectl get pod --namespace=rt | grep rt-deploy | awk '{print $1}')

    # Launch shell on pod directly
    kubectl exec --namespace=rt -it $POD -c rt-run -- /bin/bash

    # Run database initialisation command
    /opt/rt4/sbin/rt-setup-database --action init --skip-create


## RT config

TODO
