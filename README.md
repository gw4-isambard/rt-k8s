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

To modify and redeploy the RT container, delete and recreate the deployment:

    kubectl delete deployment --namespace=$NS rt-deploy
    kubectl create --namespace=$NS -f rt-pod.yaml

## RT config

To enable ticket creation via email:
- Admin -> Queues -> Select
- Click on the `General` queue.
- Click `Group Rights`, and select `Everyone` (on the left)
- Check the `Create tickets` and `Reply to tickets` boxes
- Click `Save Changes`

Create a group for operators:
- Admin -> Groups -> Create
- Name: "Operator", Description: "All RT operators"
- Admin -> Global -> Group Rights
- Entry `Operator` into the `ADD GROUP` field
- Select `Operator` under `USER GROUPS`
- Check *everything* in the `General Rights` and the `Rights for Staff` categories
- Check `Modify queue watchers` and `Show Admin menu` in the `Rights for Administrators` category
- Click `Save Changes`

To create a new operator:
- Admin -> Users -> Create
- Fill in `Username`, `E-mail`, `Real Name`, and `Organisation` fields
- Check the `Let this user be granted rights (Privileged)` box
- Click `Create`
- Admin -> Groups -> Select
- Select the `Operator` group
- Click `Members`
- `Add user: <enter username>`, click username when it comes up

Create institutional queues:
- Admin -> Queues -> Create
- Create the following queues
  - Name: `bath`, Description: Tickets for University of Bath users
  - Name: `bristol`, Description: Tickets for University of Bristol users
  - Name: `cardiff`, Description: Tickets for Cardiff University users
  - Name: `exeter`, Description: Tickets for University of Exeter users
  - Name: `metoffice`, Description: Tickets for Met Office users
- Admin -> Queues -> Select
- Select the `general` queue
- Click `Scrips` -> `Create`
  - Description: Route new tickets by domain
  - Condition: On Create
  - Action: User Defined
  - Template: Blank
  - Stage: Normal
  - Custom action preparation code: `return 1;`
  - Custom action commit code:
```
# Domains we want to move
my $domains = {};

my %domain_map = (
                   '\@bath\.ac\.uk'             => "bath",
                   '\@bristol\.ac\.uk'          => "bristol",
                   '\@cardiff\.ac\.uk'          => "cardiff",
                   '\@exeter\.ac\.uk'          => "exeter",
                   '\@metoffice\.gov\.uk'   => "metoffice",
                );

#Check each of our defined domains for a match
foreach my $domainKey (keys %domain_map ){
if($self->TicketObj->RequestorAddresses =~ /^.*?${domainKey}/) {
    # Domain matches - move to the right queue
    $self->TicketObj->SetQueue($domain_map{$domainKey});
    }
}
```
  - Click `Save Changes`

Change the auto-reply template (or any other templates):
- Admin -> Global -> Templates -> Select
- Select the `Autoreply in HTML` template
- Modify as necessary, then click `Save Changes`


## Operator usage info

Change your password:
- Under `Logged in as <user>` at the top, click `Settings` -> `About me`
- Under `Access control`, enter old password and new password
- Click `Save Preferences`

Subscribe to a queue:
- Admin -> Queues -> Select
- Select the queue you wish to subscribe to
- Click `Watchers`
- Search for your username
- In the drop down box that appears, select `AdminCc` next to your username
- Click `Save Changes`
