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

## Building the Docker image

If using a different DockerHub repository or image name (set to `jrprice/isambard-rt` below), the `rt-pod.yaml` needs to be updated to point to it.

    cd docker/rt
    docker build -t isambard-rt .
    docker tag isambard-rt jrprice/isambard-rt
    docker push jrprice/isambard-rt


## Kubernetes

Create a namespace:

    export NS=rt
    kubectl create namespace $NS

Initialise/update helm:

    helm init --upgrade

Set up NGINX ingress:

    helm install --namespace=$NS stable/nginx-ingress

    # Get external IP address (may take a few minutes)
    kubectl get service --namespace=$NS

Start the service:

    kubectl create --namespace=$NS -f rt-svc.yaml
    kubectl apply --namespace=$NS -f rt-ingress.yaml

Create the PVC:

    kubectl create  --namespace=$NS -f rt-pvc.yaml

Create Kubernetes secrets:

    kubectl create secret generic --namespace=$NS mail-user --from-file=username=./mail-user.txt
    kubectl create secret generic --namespace=$NS mail-pass --from-file=password=./mail-pass.txt
    kubectl create secret generic --namespace=$NS db-pass --from-file=password=./db-pass.txt

Start the deployment:

    kubectl create --namespace=$NS -f rt-pod.yaml

Initialise the RT database:

    # Get name of pod
    POD=$(kubectl get pod --namespace=$NS | grep rt-deploy | awk '{print $1}')

    # Launch shell on pod directly
    kubectl exec --namespace=$NS -it $POD -c rt-run -- /bin/bash

    # Run database initialisation command
    /opt/rt4/sbin/rt-setup-database --action init --skip-create

Setup LetsEncrypyt

    helm install stable/kube-lego --namespace $NS --set config.LEGO_EMAIL=isambard-support,config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory,rbac.create=true

## RT config

To enable ticket creation via email, we need to grant the `Everyone` group permission to comment and create on tickets:
- Admin -> Queues -> Select
- Click on the `General` queue.
- Click `Group Rights` (the `Everyone` group should be selected by default)
- Check the `Comment on tickets` and `Create tickets` boxes
- Click `Save Changes`
